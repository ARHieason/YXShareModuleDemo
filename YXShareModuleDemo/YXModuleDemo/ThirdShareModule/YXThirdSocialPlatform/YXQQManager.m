
#import "YXQQManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface YXQQManager () <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, copy) GetTokenAndOpenidComleteBlock getTokenAndOpenidComleteBlock;

@property (nonatomic, copy) YXAuthSuccess  authSuccess;
@property (nonatomic, copy) YXAuthError    authError;
@property (nonatomic, copy) YXLoginSuccess loginSuccess;
@property (nonatomic, copy) YXLoginError   loginError;

@end

@implementation YXQQManager

+ (instancetype)manager {
    static id QQManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QQManager = [[YXQQManager alloc] init];
    });
    return QQManager;
}

- (id)init {
    if (self = [super init]) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:self];
    }
    return self;
}

+ (BOOL)isAppInstalled {
    if ([TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin]) {
        return YES;
    }
    return NO;
}

+ (void)installApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[QQApiInterface getQQInstallUrl]]];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    if ([QQApiInterface handleOpenURL:url delegate:[YXQQManager manager]]) {
        return YES;
    }
    return [TencentOAuth HandleOpenURL:url];
}

+ (void)authRequestWithAuthSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError {
    YXQQManager *manager = [YXQQManager manager];
    manager.authSuccess = authSuccess;
    manager.authError = authError;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    [manager.tencentOAuth authorize:@[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]];
}

+ (void)loginRequestWithLoginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError {
    YXQQManager *manager = [YXQQManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = loginSuccess;
    manager.loginError = loginError;
    [manager.tencentOAuth authorize:@[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]];
}

+ (void)sendAuthToGetTokenAndOpenidComleteBlock:(GetTokenAndOpenidComleteBlock)block {
    YXQQManager *manager = [YXQQManager manager];
    manager.getTokenAndOpenidComleteBlock = block;
    [manager.tencentOAuth authorize:@[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]];
}

#pragma mark - TencentLoginDelegate

- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken && _tencentOAuth.accessToken.length > 0) {
        if (self.getTokenAndOpenidComleteBlock) {
            self.getTokenAndOpenidComleteBlock(nil, _tencentOAuth.accessToken, _tencentOAuth.openId);
        }
        if (self.authSuccess) {
            self.authSuccess(self.tencentOAuth.openId, nil);
        }
        [self.tencentOAuth getUserInfo];
    } else {
        if (self.authError) {
            self.authError([NSError errorWithDomain:@"QQ登录失败" code:-1 userInfo:nil]);
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        if (self.authError) {
            self.authError([NSError errorWithDomain:@"用户取消QQ登录" code:-1 userInfo:nil]);
        }
    } else {
        if (self.authError) {
            self.authError([NSError errorWithDomain:@"QQ登录失败" code:-1 userInfo:nil]);
        }
    }
}

- (void)tencentDidNotNetWork {
    if (self.authError) {
        self.authError([NSError errorWithDomain:@"QQ登录网络错误" code:-1 userInfo:nil]);
    }
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSString *nickname  = response.jsonResponse[@"nickname"];
        NSString *avatarURL = response.jsonResponse[@"figureurl_qq_2"];
        if (self.loginSuccess) {
            self.loginSuccess(self.tencentOAuth.openId, nil, nickname, avatarURL);
        }
    } else {
        if (self.loginError) {
            self.loginError([NSError errorWithDomain:@"QQ登录异常" code:-1 userInfo:nil]);
        }
    }
}

#pragma mark - QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req { }

- (void)onResp:(QQBaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *tmpResp = (SendMessageToQQResp *)resp;
        if (tmpResp.type == ESENDMESSAGETOQQRESPTYPE && [tmpResp.result integerValue] == 0) {
            NSLog(@"QQ分享成功");
            if (self.shareResultBlock) {
                self.shareResultBlock(YES, nil);
            }
        } else {
            NSLog(@"QQ分享失败");
            if (self.shareResultBlock) {
                
                self.shareResultBlock(NO, [NSError errorWithDomain:@"发送参数错误" code:EQQAPIMESSAGECONTENTINVALID userInfo:nil]);
            }
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response { }

- (void)handleSendResult:(QQApiSendResultCode)sendResult {
    
    NSError *error = nil;
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED: {
            error = [NSError errorWithDomain:@"APP未注册" code:EQQAPIAPPNOTREGISTED userInfo:nil];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID: {
            error = [NSError errorWithDomain:@"发送参数错误" code:EQQAPIMESSAGECONTENTINVALID userInfo:nil];
            break;
        }
        case EQQAPIQQNOTINSTALLED: {
            error = [NSError errorWithDomain:@"未安装手机QQ" code:EQQAPIQQNOTINSTALLED userInfo:nil];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI: {
            error = [NSError errorWithDomain:@"API接口不支持" code:EQQAPIQQNOTSUPPORTAPI userInfo:nil];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE: {
            error = [NSError errorWithDomain:@"当前QQ版本太低" code:EQQAPIVERSIONNEEDUPDATE userInfo:nil];
            break;
        }
        case EQQAPISENDFAILD: {
            error = [NSError errorWithDomain:@"发送失败" code:EQQAPISENDFAILD userInfo:nil];
            break;
        }
        default: {
            break;
        }
    }
    if (error) {
        if (self.shareResultBlock) {
            self.shareResultBlock(NO, error);
        }
    }
}

@end
