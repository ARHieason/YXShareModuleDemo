
#import <Foundation/Foundation.h>
#import "YXShareTool.h"

// **SDK依赖的系统库**
// Security.framework
// libiconv.dylib
// SystemConfiguration.framework
// CoreGraphics.Framework
// libsqlite3.dylib
// CoreTelephony.framework
// libstdc++.dylib
// libz.dylib

typedef void (^GetTokenAndOpenidComleteBlock)(NSError *error, NSString *token, NSString *openid);

@interface YXQQManager : NSObject

@property (nonatomic, copy) YXShareResultBlock shareResultBlock;

+ (instancetype)manager;

+ (BOOL)isAppInstalled;

+ (void)installApp;

+ (BOOL)handleOpenURL:(NSURL *)url;


+ (void)authRequestWithAuthSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError;

+ (void)sendAuthToGetTokenAndOpenidComleteBlock:(GetTokenAndOpenidComleteBlock)block;

@end
