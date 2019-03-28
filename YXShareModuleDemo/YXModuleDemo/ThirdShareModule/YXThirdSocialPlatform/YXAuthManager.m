
#import "YXAuthManager.h"
#import "YXWeixinManager.h"
#import "YXWeiboManager.h"
#import "YXQQManager.h"

@implementation YXAuthManager

+ (void)registerApp {
    [YXWeixinManager registerApp];
    [YXWeiboManager registerApp];
}

+ (BOOL)isAppInstalled:(YXAuthType)authType {
    BOOL result = NO;
    switch (authType) {
        case YXAuthTypeWeixin: {
            result = [YXWeixinManager isAppInstalled];
            break;
        }
        case YXAuthTypeWeibo: {
            result = [YXWeiboManager isAppInstalled];
            break;
        }
        case YXAuthTypeQQ: {
            result = [YXQQManager isAppInstalled];
            break;
        }
    }
    return result;
}

+ (void)installeAPP:(YXAuthType)authType {
    switch (authType) {
        case YXAuthTypeWeixin: {
            [YXWeixinManager installApp];
            break;
        }
        case YXAuthTypeWeibo: {
            [YXWeiboManager installApp];
            break;
        }
        case YXAuthTypeQQ: {
            [YXQQManager installApp];
            break;
        }
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    if ([YXWeixinManager handleOpenURL:url]) {
        return YES;
    }
    if ([YXWeiboManager handleOpenURL:url]) {
        return YES;
    }
    if ([YXQQManager handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

+ (void)authRequest:(YXAuthType)authType authSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError {
    switch (authType) {
        case YXAuthTypeWeixin: {
            [YXWeixinManager authRequestWithAuthSuccess:authSuccess authError:authError];
            break;
        }
        case YXAuthTypeWeibo: {
            [YXWeiboManager authRequestWithAuthSuccess:authSuccess authError:authError];
            break;
        }
        case YXAuthTypeQQ: {
            [YXQQManager authRequestWithAuthSuccess:authSuccess authError:authError];
            break;
        }
    }
}

+ (void)loginRequest:(YXAuthType)authType loginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError {
    switch (authType) {
        case YXAuthTypeWeixin: {
            [YXWeixinManager loginRequestWithLoginSuccess:loginSuccess loginError:loginError];
            break;
        }
        case YXAuthTypeWeibo: {
            [YXWeiboManager loginRequestWithLoginSuccess:loginSuccess loginError:loginError];
            break;
        }
        case YXAuthTypeQQ: {
            [YXQQManager loginRequestWithLoginSuccess:loginSuccess loginError:loginError];
            break;
        }
    }
}

@end
