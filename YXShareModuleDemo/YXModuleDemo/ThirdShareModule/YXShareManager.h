

#import <Foundation/Foundation.h>
#import "YXShareTool.h"

typedef NS_OPTIONS (NSInteger, YXShareType) {
    YXShareType_H5,
    YXShareType_Image
};

typedef NS_OPTIONS (NSInteger, YXAppType) {
    YXAppType_QQ,
    YXAppType_WeiXin,
    YXAppType_Weibo
};

@interface YXShareManager : NSObject

+ (BOOL)isAppInstalled:(YXAppType)appType;

+ (void)shareToWeixinFrendWithTitle:(NSString *)title
                        description:(NSString *)description
                        resourceURL:(NSString *)resourceURL
                         thumbImage:(UIImage  *)thumbImage
                         shareImage:(UIImage  *)shareImage
                          shareType:(YXShareType)shareType
                        shareResult:(YXShareResultBlock)shareResultBlock;

+ (void)shareToWeixinPengyouquanWithTitle:(NSString *)title
                              description:(NSString *)description
                              resourceURL:(NSString *)resourceURL
                               thumbImage:(UIImage  *)thumbImage
                               shareImage:(UIImage  *)shareImage
                                shareType:(YXShareType)shareType
                              shareResult:(YXShareResultBlock)shareResultBlock;

+ (void)shareToWeiboWithTitle:(NSString *)title
                  description:(NSString *)description
                  resourceURL:(NSString *)resourceURL
                   shareImage:(UIImage  *)shareImage
                  shareResult:(YXShareResultBlock)shareResultBlock;

+ (void)shareToQQFriendWithTitle:(NSString *)title
                     description:(NSString *)description
                     resourceURL:(NSString *)resourceURL
                      thumbImage:(UIImage  *)thumbImage
                     shareResult:(YXShareResultBlock)shareResultBlock;

+ (void)shareToQQZoneWithTitle:(NSString *)title
                   description:(NSString *)description
                   resourceURL:(NSString *)resourceURL
                    thumbImage:(UIImage  *)thumbImage
                   shareResult:(YXShareResultBlock)shareResultBlock;


@end
