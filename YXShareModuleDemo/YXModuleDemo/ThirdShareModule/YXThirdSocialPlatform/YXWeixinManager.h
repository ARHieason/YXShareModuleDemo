
#import <Foundation/Foundation.h>
#import "YXShareTool.h"

// **SDK依赖的系统库**
// SystemConfiguration.framework
// libz.dylib
// libsqlite3.0.dylib
// libc++.dylib
// CoreTelephony.framework

typedef void (^GetCodeComleteBlock)(NSError *error, NSString *code);

@interface YXWeixinManager : NSObject

@property (nonatomic, copy) YXShareResultBlock shareResultBlock;

+ (instancetype)manager;

+ (void)registerApp;

+ (BOOL)isAppInstalled;

+ (void)installApp;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequestWithAuthSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError;

+ (void)sendAuthToGetCodeComleteBlock:(GetCodeComleteBlock)block;

@end
