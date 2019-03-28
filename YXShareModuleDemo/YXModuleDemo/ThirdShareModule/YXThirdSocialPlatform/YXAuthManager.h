
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXShareTool.h"

typedef NS_OPTIONS (NSInteger, YXAuthType) {
    YXAuthTypeQQ,
    YXAuthTypeWeibo,
    YXAuthTypeWeixin
};

@interface YXAuthManager : NSObject

+ (void)registerApp;

+ (BOOL)isAppInstalled:(YXAuthType)authType;

+ (void)installeAPP:(YXAuthType)authType;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequest:(YXAuthType)authType authSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError;

+ (void)loginRequest:(YXAuthType)authType loginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError;

@end
