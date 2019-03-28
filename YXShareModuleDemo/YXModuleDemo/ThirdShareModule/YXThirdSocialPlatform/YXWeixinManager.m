
#import "YXWeixinManager.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface YXWeixinManager () <WXApiDelegate>

@property (nonatomic, copy) GetCodeComleteBlock getCodeComleteBlock;

@property (nonatomic, copy) YXAuthSuccess  authSuccess;
@property (nonatomic, copy) YXAuthError    authError;
@property (nonatomic, copy) YXLoginSuccess loginSuccess;
@property (nonatomic, copy) YXLoginError   loginError;

@end

@implementation YXWeixinManager

+ (void)registerApp {
    if ([WXApi registerApp:WX_APPKEY]) {
        NSLog(@"Weixin registerApp success");
    }
}

+ (BOOL)isAppInstalled {
    return [WXApi isWXAppInstalled];
}

+ (void)installApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[YXWeixinManager manager]];
}

+ (instancetype)manager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXWeixinManager alloc] init];
    });
    return manager;
}

+ (void)authRequestWithAuthSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError {
    YXWeixinManager *manager = [YXWeixinManager manager];
    manager.authSuccess = authSuccess;
    manager.authError = authError;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    
    SendAuthReq *sendAuthReq = [[SendAuthReq alloc] init];
    sendAuthReq.scope = @"snsapi_userinfo";
    sendAuthReq.state = @"413e6ad8cae81487d315780b0a6717c0";
    [WXApi sendAuthReq:sendAuthReq viewController:nil delegate:[YXWeixinManager manager]];
}

+ (void)loginRequestWithLoginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError {
    YXWeixinManager *manager = [YXWeixinManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = loginSuccess;
    manager.loginError = loginError;
    
    SendAuthReq *sendAuthReq = [[SendAuthReq alloc] init];
    sendAuthReq.scope = @"snsapi_userinfo";
    sendAuthReq.state = @"413e6ad8cae81487d315780b0a6717c0";
    [WXApi sendAuthReq:sendAuthReq viewController:nil delegate:[YXWeixinManager manager]];
}

+ (void)sendAuthToGetCodeComleteBlock:(GetCodeComleteBlock)block {
    YXWeixinManager *manager = [YXWeixinManager manager];
    manager.getCodeComleteBlock = block;
    
    SendAuthReq *sendAuthReq = [[SendAuthReq alloc] init];
    sendAuthReq.scope = @"snsapi_userinfo";
    sendAuthReq.state = @"413e6ad8cae81487d315780b0a6717c0";
    [WXApi sendAuthReq:sendAuthReq viewController:nil delegate:[YXWeixinManager manager]];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req { }

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == WXSuccess) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            if (self.getCodeComleteBlock) {
                self.getCodeComleteBlock(nil, authResp.code);
            } else {
                [self getOpenIDWithCode:authResp.code];
            }
        } else {
            if (self.authError) {
                if (resp.errCode == WXErrCodeAuthDeny) {
                    self.authError([NSError errorWithDomain:@"微信用户拒绝授权" code:resp.errCode userInfo:nil]);
                } else if (resp.errCode == WXErrCodeUserCancel) {
                    self.authError([NSError errorWithDomain:@"微信用户取消授权" code:resp.errCode userInfo:nil]);
                } else {
                    self.authError([NSError errorWithDomain:@"微信用户授权失败" code:resp.errCode userInfo:nil]);
                }
            }
        }
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == WXSuccess) {
            if (self.shareResultBlock) {
                self.shareResultBlock(YES, nil);
            }
        } else {
            if (self.shareResultBlock) {
                NSError *error = [NSError errorWithDomain:@"微信分享失败" code:resp.errCode userInfo:nil];
                if (resp.errCode == WXErrCodeUserCancel) {
                    error = [NSError errorWithDomain:@"用户取消微信分享" code:resp.errCode userInfo:nil];
                }
                self.shareResultBlock(NO, error);
            }
        }
    }
}

- (void)getOpenIDWithCode:(NSString *)code {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *URLStringHeader = @"https://api.weixin.qq.com/sns/oauth2/access_token";
    NSString *URLString = [NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code", URLStringHeader, WX_APPKEY, WX_SECRET, code];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:URLString]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    if (self.authError) {
                                                        self.authError(error);
                                                        return;
                                                    }
                                                }
                                                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                               options:NSJSONReadingMutableLeaves error:nil];
                                                if ([self occurError:responseObject]) {
                                                    return;
                                                }
                                                [self loginWithOpenId:responseObject[@"openid"] token:responseObject[@"access_token"]];
                                            });
                                        }];
    [task resume];
}

- (void)loginWithOpenId:(NSString *)openID token:(NSString *)token {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *URLStringHeader = @"https://api.weixin.qq.com/sns/userinfo";
    NSString *URLString = [NSString stringWithFormat:@"%@?access_token=%@&openid=%@", URLStringHeader, token, openID];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:URLString]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    if (self.authError) {
                                                        self.authError(error);
                                                        return;
                                                    }
                                                    if (self.loginError) {
                                                        self.loginError(error);
                                                        return;
                                                    }
                                                }
                                                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                               options:NSJSONReadingMutableLeaves error:nil];
                                                if ([self occurError:responseObject]) {
                                                    return;
                                                }
                                                NSString *openid = responseObject[@"openid"];
                                                NSString *unionid = responseObject[@"unionid"];
                                                NSString *nickname = responseObject[@"nickname"];
                                                NSString *avatarURL = responseObject[@"headimgurl"];
                                                if (self.authSuccess) {
                                                    self.authSuccess(openid, unionid);
                                                }
                                                if (self.loginSuccess) {
                                                    self.loginSuccess(openid, unionid, nickname, avatarURL);
                                                }
                                            });
                                        }];
    [task resume];
}

- (BOOL)occurError:(NSDictionary *)responseObject {
    if (responseObject[@"errcode"]) {
        NSString *errmsg = responseObject[@"errmsg"];
        NSInteger errcode = [responseObject[@"errcode"] integerValue];
        if (self.authError) {
            self.authError([NSError errorWithDomain:errmsg code:errcode userInfo:nil]);
        }
        return YES;
    }
    return NO;
}

@end
