
#import "YXWeiboManager.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

@interface YXWeiboManager () <WeiboSDKDelegate>

@property (nonatomic, copy) GetTokenAndOpenidComleteBlock getTokenAndOpenidComleteBlock;

@property (nonatomic, copy) YXAuthSuccess  authSuccess;
@property (nonatomic, copy) YXAuthError    authError;
@property (nonatomic, copy) YXLoginSuccess loginSuccess;
@property (nonatomic, copy) YXLoginError   loginError;

@end

@implementation YXWeiboManager

+ (void)registerApp {
    if ([WeiboSDK registerApp:WB_APPKEY]) {
        NSLog(@"Weibo registerApp success");
    }
}

+ (BOOL)isAppInstalled {
    return ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanSSOInWeiboApp]);
}

+ (void)installApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WeiboSDK getWeiboAppInstallUrl]]];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:[YXWeiboManager manager]];
}

+ (instancetype)manager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXWeiboManager alloc] init];
    });
    return manager;
}

+ (void)authRequestWithAuthSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError {
    YXWeiboManager *manager = [YXWeiboManager manager];
    manager.authSuccess = authSuccess;
    manager.authError = authError;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    manager.getTokenAndOpenidComleteBlock = nil;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

+ (void)loginRequestWithLoginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError {
    YXWeiboManager *manager = [YXWeiboManager manager];
    manager.getTokenAndOpenidComleteBlock = nil;
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = loginSuccess;
    manager.loginError = loginError;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

+ (void)sendAuthToGetTokenAndOpenidComleteBlock:(GetTokenAndOpenidComleteBlock)block {
    YXWeiboManager *manager = [YXWeiboManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    manager.getTokenAndOpenidComleteBlock = block;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request { }

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBAuthorizeResponse *resp = (WBAuthorizeResponse *)response;
            if (self.getTokenAndOpenidComleteBlock) {
                self.getTokenAndOpenidComleteBlock(nil, resp.accessToken, resp.userID);
            }
            if (self.authSuccess) {
                self.authSuccess(resp.userID, nil);
            }
            [self loginRequest:resp];
        } else {
            if (self.authError) {
                if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
                    self.authError([NSError errorWithDomain:@"用户拒绝微博授权" code:response.statusCode userInfo:nil]);
                } else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                    self.authError([NSError errorWithDomain:@"用户取消微博授权" code:response.statusCode userInfo:nil]);
                } else {
                    self.authError([NSError errorWithDomain:@"微博授权失败" code:response.statusCode userInfo:nil]);
                }
            }
        }
    } else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            if (self.shareResultBlock) {
                self.shareResultBlock(YES, nil);
            }
        } else {
            if (self.shareResultBlock) {
                NSError *error = [NSError errorWithDomain:@"微博分享失败" code:response.statusCode userInfo:nil];
                if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                    [NSError errorWithDomain:@"用户取消微博分享" code:response.statusCode userInfo:nil];
                }
                self.shareResultBlock(NO, error);
            }
        }
    }
    
    
}

- (void)loginRequest:(WBAuthorizeResponse *)resp {
    [WBHttpRequest requestForUserProfile:resp.userID
                         withAccessToken:resp.accessToken
                      andOtherProperties:nil
                                   queue:nil
                   withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                       if (!error) {
                           WeiboUser *userInfo = (WeiboUser *)result;
                           NSString *userID = userInfo.userID;
                           NSString *nickname = userInfo.name;
                           NSString *avatarURL = userInfo.avatarLargeUrl;
                           if (self.loginSuccess) {
                               self.loginSuccess(userID, nil, nickname, avatarURL);
                           }
                       } else {
                           if (self.loginError) {
                               self.loginError(error);
                           }
                       }
                   }];
}

@end
