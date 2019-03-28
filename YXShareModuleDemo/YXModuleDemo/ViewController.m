//
//  ViewController.m
//  YXModuleDemo
//
//  Created by wangtao on 2019/1/11.
//  Copyright © 2019年 wangtao. All rights reserved.
//

#import "ViewController.h"
#import "YXShareManager.h"
#import "YXCustomAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shareTest];
}

- (void)shareTest {
    NSArray *array = @[@"分享到微信",@"分享到朋友圈",@"分享到微博",@"QQ朋友",@"QQ空间"];
    for (NSInteger index = 0; index < array.count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 100 + 60 * index, 150, 50);
        button.backgroundColor = [UIColor redColor];
        button.tag = index;
        [button setTitle:array[index] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)sender {
    
    YXCustomAlertView *alertView = [[YXCustomAlertView alloc] initWithLeftButtonTitle:@"取消" rightButtonTitle:@"确定"];
    [alertView setTitleTipsLableText:@"提示"];
    if (![YXShareManager isAppInstalled:YXAppType_Weibo] && sender.tag == 2) {
        [alertView setIntroTipsLableText:@"没有安装微博"];
        [alertView show];
        return;
    }
    
    if (![YXShareManager isAppInstalled:YXAppType_QQ] && (sender.tag == 3 || sender.tag ==4)) {
        [alertView setIntroTipsLableText:@"没有安装QQ"];
        [alertView show];
        return;
    }
    
    if (![YXShareManager isAppInstalled:YXAppType_WeiXin] && (sender.tag == 0 || sender.tag == 1)) {
        [alertView setIntroTipsLableText:@"没有安装微信"];
        [alertView show];
        return;
    }
    
    if (sender.tag == 0) {
        [YXShareManager shareToWeixinFrendWithTitle:@"title" description:@"description" resourceURL:@"http://baidu.com" thumbImage:[UIImage imageNamed:@"IMG_1887.JPG"] shareImage:[UIImage imageNamed:@"IMG_1887.JPG"] shareType:YXShareType_H5 shareResult:^(BOOL success, NSError * _Nonnull error) {
            
        }];
    } else if (sender.tag == 1) {
        [YXShareManager shareToWeixinPengyouquanWithTitle:@"title" description:@"description" resourceURL:@"http://baidu.com" thumbImage:[UIImage imageNamed:@"IMG_1887.JPG"] shareImage:[UIImage imageNamed:@"IMG_1887.JPG"] shareType:YXShareType_Image shareResult:^(BOOL success, NSError * _Nonnull error) {
            
        }];
    } else if (sender.tag == 2){
        [YXShareManager shareToWeiboWithTitle:@"1232" description:@"23545" resourceURL:@"http://baidu.com" shareImage:nil shareResult:^(BOOL success, NSError * _Nonnull error) {
            
        }];
    } else if (sender.tag == 3) {
        [YXShareManager shareToQQFriendWithTitle:@"title" description:@"description" resourceURL:@"http://baidu.com" thumbImage:[UIImage imageNamed:@"IMG_1887.JPG"] shareResult:^(BOOL success, NSError * _Nonnull error) {
            
        }];
    } else if (sender.tag == 4) {
        [YXShareManager shareToQQZoneWithTitle:@"title" description:@"description" resourceURL:@"http://baidu.com" thumbImage:[UIImage imageNamed:@"IMG_1887.JPG"] shareResult:^(BOOL success, NSError * _Nonnull error) {
            
        }];
    }
    
}

@end
