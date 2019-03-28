//
//  ShareObject.m
//  yixun
//
//  Created by 王涛 on 2017/2/13.
//  Copyright © 2017年 again. All rights reserved.
//

#import "YXShareManager.h"
#import "YXWeiboManager.h"
#import "YXWeixinManager.h"
#import "YXQQManager.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>


@interface YXShareManager ()

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *H5ShareTitle;

@end

@implementation YXShareManager

+ (instancetype)sharedManager {
    static YXShareManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (BOOL)isAppInstalled:(YXAppType)appType {
    if (appType == YXAppType_QQ) {
        return [YXQQManager isAppInstalled];
    } else if (appType == YXAppType_Weibo) {
        return [YXWeiboManager isAppInstalled];
    } else {
        return [YXWeixinManager isAppInstalled];
    }
}

+ (void)shareToWeixinFrendWithTitle:(NSString *)title
                        description:(NSString *)description
                        resourceURL:(NSString *)resourceURL
                         thumbImage:(UIImage  *)thumbImage
                         shareImage:(UIImage  *)shareImage
                          shareType:(YXShareType)shareType
                        shareResult:(YXShareResultBlock)shareResultBlock
{
    YXWeixinManager *manager = [YXWeixinManager manager];
    manager.shareResultBlock = shareResultBlock;

    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    mediaMessage.title = title;
    mediaMessage.description = description;
    mediaMessage.thumbData = UIImageJPEGRepresentation(thumbImage, 0.01);

    if (shareType == YXShareType_H5) {
        WXWebpageObject *webPage = [WXWebpageObject object];
        webPage.webpageUrl = resourceURL;
        mediaMessage.mediaObject = webPage;
    } else {
        WXImageObject *imageObject   = [WXImageObject object];
        imageObject.imageData        = UIImagePNGRepresentation(shareImage);
        mediaMessage.mediaObject     = imageObject;
    }

    SendMessageToWXReq *sendMessageToWXReq = [[SendMessageToWXReq alloc] init];
    sendMessageToWXReq.bText = NO;
    sendMessageToWXReq.message = mediaMessage;
    sendMessageToWXReq.scene = WXSceneSession;
    [WXApi sendReq:sendMessageToWXReq];
}

+ (void)shareToWeixinPengyouquanWithTitle:(NSString *)title
                              description:(NSString *)description
                              resourceURL:(NSString *)resourceURL
                               thumbImage:(UIImage  *)thumbImage
                               shareImage:(UIImage  *)shareImage
                                shareType:(YXShareType)shareType
                              shareResult:(YXShareResultBlock)shareResultBlock
{
    YXWeixinManager *manager = [YXWeixinManager manager];
    manager.shareResultBlock = shareResultBlock;
    
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    mediaMessage.title = title;
    mediaMessage.description = description;
    mediaMessage.thumbData = UIImageJPEGRepresentation(thumbImage, 0.01);
    
    if (shareType == YXShareType_H5) {
        WXWebpageObject *webPage = [WXWebpageObject object];
        webPage.webpageUrl = resourceURL;
        mediaMessage.mediaObject = webPage;
    } else {
        WXImageObject *imageObject   = [WXImageObject object];
        imageObject.imageData        = UIImagePNGRepresentation(shareImage);
        mediaMessage.mediaObject     = imageObject;
    }

    SendMessageToWXReq *sendMessageToWXReq = [[SendMessageToWXReq alloc] init];
    sendMessageToWXReq.bText = NO;
    sendMessageToWXReq.message = mediaMessage;
    sendMessageToWXReq.scene = WXSceneTimeline;
    [WXApi sendReq:sendMessageToWXReq];
}

+ (void)shareToWeiboWithTitle:(NSString *)title
                  description:(NSString *)description
                  resourceURL:(NSString *)resourceURL
                   shareImage:(UIImage  *)shareImage
                  shareResult:(YXShareResultBlock)shareResultBlock
{
    YXWeiboManager *manager = [YXWeiboManager manager];
    manager.shareResultBlock = shareResultBlock;
    WBMessageObject *messageObject = [WBMessageObject message];
    messageObject.text = [NSString stringWithFormat:@"%@ %@ %@", title, description, resourceURL];
    
    if (shareImage) {
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImagePNGRepresentation(shareImage);
        messageObject.imageObject = imageObject;
    }
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    authRequest.shouldShowWebViewForAuthIfCannotSSO = YES;
    authRequest.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    WBSendMessageToWeiboRequest *sendMessageToWeiboRequest = [WBSendMessageToWeiboRequest requestWithMessage:messageObject
                                                                                                    authInfo:authRequest
                                                                                                access_token:nil];
    sendMessageToWeiboRequest.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:sendMessageToWeiboRequest];
}

+ (void)shareToQQFriendWithTitle:(NSString *)title
                     description:(NSString *)description
                     resourceURL:(NSString *)resourceURL
                      thumbImage:(UIImage  *)thumbImage
                     shareResult:(YXShareResultBlock)shareResultBlock
{
    if (!thumbImage) {
        if (shareResultBlock) {
            shareResultBlock(NO, [NSError errorWithDomain:@"缺少分享图片" code:1 userInfo:nil]);
        }
        return;
    }
    
    YXQQManager *manager = [YXQQManager manager];
    manager.shareResultBlock = shareResultBlock;
    
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:resourceURL]
                                                           title:title
                                                     description:description
                                                previewImageData:UIImagePNGRepresentation(thumbImage)];
    SendMessageToQQReq *sendMessageToQQReq = [SendMessageToQQReq reqWithContent:newsObject];
    QQApiSendResultCode sendResultCode = [QQApiInterface sendReq:sendMessageToQQReq];
//    [manager handleSendResult:sendResultCode];
}

+ (void)shareToQQZoneWithTitle:(NSString *)title
                   description:(NSString *)description
                   resourceURL:(NSString *)resourceURL
                    thumbImage:(UIImage  *)thumbImage
                   shareResult:(YXShareResultBlock)shareResultBlock
{
    if (!thumbImage) {
        if (shareResultBlock) {
            shareResultBlock(NO, [NSError errorWithDomain:@"缺少分享图片" code:1 userInfo:nil]);
        }
        return;
    }
    
    YXQQManager *manager = [YXQQManager manager];
    manager.shareResultBlock = shareResultBlock;
    
    QQApiNewsObject *newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:resourceURL]
                                                           title:title
                                                     description:description
                                                previewImageData:UIImagePNGRepresentation(thumbImage)];
    SendMessageToQQReq *sendMessageToQQReq = [SendMessageToQQReq reqWithContent:newsObject];
    QQApiSendResultCode sendResultCode = [QQApiInterface SendReqToQZone:sendMessageToQQReq];
//    [manager handleSendResult:sendResultCode];
}


@end
