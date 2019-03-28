//
//  YXShareTool.h
//  YXModuleDemo
//
//  Created by wangtao on 2019/1/14.
//  Copyright © 2019年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


#define WX_APPKEY      @"wx54d6c697c94691b1"
#define WX_SECRET      @"60a3cc82c4f5c3b80ddcd5b3c5811a27"

#define WB_APPKEY      @"2661744413"
#define WB_SECRET      @"6e0ba5ce40fa1722f46e309b3ced35af"
#define WB_RedirectURI @"http://www.arhieason.com/"

#define QQ_APPID       @"1104784464"
#define QQ_APPKEY      @"2ejPhOgTmjIQqkDC"

@interface YXShareTool : NSObject

typedef void (^YXAuthSuccess)(NSString *openID, NSString *unionID);
typedef void (^YXAuthError)(NSError *error);

typedef void (^YXLoginSuccess)(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL);
typedef void (^YXLoginError)(NSError *error);

typedef void (^YXShareResultBlock)(BOOL success, NSError *error);

@end

NS_ASSUME_NONNULL_END
