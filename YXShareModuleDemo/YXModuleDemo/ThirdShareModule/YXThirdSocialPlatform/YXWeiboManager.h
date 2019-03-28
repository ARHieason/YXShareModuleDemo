

#import <Foundation/Foundation.h>
#import "YXShareTool.h"

// **SDK依赖的系统库**
// QuartzCore.framework
// ImageIO.framework
// SystemConfiguration.framework
// Security.framework
// CoreTelephony.framework
// CoreText.framework
// UIKit.framework
// Foundation.framework
// CoreGraphics.framework

typedef void (^GetTokenAndOpenidComleteBlock)(NSError *error, NSString *token, NSString *openid);

@interface YXWeiboManager : NSObject

@property (nonatomic, copy) YXShareResultBlock shareResultBlock;

+ (instancetype)manager;

+ (void)registerApp;

+ (BOOL)isAppInstalled;

+ (void)installApp;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequestWithAuthSuccess:(YXAuthSuccess)authSuccess authError:(YXAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(YXLoginSuccess)loginSuccess loginError:(YXLoginError)loginError;

+ (void)sendAuthToGetTokenAndOpenidComleteBlock:(GetTokenAndOpenidComleteBlock)block;

@end
