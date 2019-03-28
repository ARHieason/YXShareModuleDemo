//
//  YXCustomAlertView.h
//  YXBigScreenClient
//
//  Created by wangtao on 2018/12/3.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LtButtonBlock)();
typedef void (^RtButtonBlock)();

@interface YXCustomAlertView : UIView

@property (nonatomic, copy) LtButtonBlock ltButtonBlock;
@property (nonatomic, copy) RtButtonBlock rtButtonBlock;

- (void)setTitleTipsLableText:(NSString *)text;
- (void)setIntroTipsLableText:(NSString *)text;
- (instancetype)initWithLeftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;
- (void)show;

@end
