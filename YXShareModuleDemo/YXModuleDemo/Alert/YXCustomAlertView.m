//
//  YXCustomAlertView.m
//  YXBigScreenClient
//
//  Created by wangtao on 2018/12/3.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import "YXCustomAlertView.h"
#import "UIView+Frame.h"


#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_ADJUST_WIDTH(width) width * ([UIScreen mainScreen].scale==1?1:1.3)

#define CONTAINER_W  (SCREEN_WIDTH - SCREEN_ADJUST_WIDTH(74))
#define CONTAINER_H  SCREEN_ADJUST_WIDTH(180)
#define CLOSEBTN_H   SCREEN_ADJUST_WIDTH(60)
#define kBtnLineBackgroundColor [UIColor colorWithRed:1.00 green:0.92 blue:0.91 alpha:1.00]

@interface YXCustomAlertView ()
{
    UILabel      *_titleTipsLable;
    UIImageView  *_tipsImageView;
    UILabel      *_introTipsLable;
}

@end

@implementation YXCustomAlertView

- (instancetype)initWithLeftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle {
    self = [super initWithFrame:SCREEN_BOUNDS];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.33];
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - CONTAINER_W * 0.5, SCREEN_HEIGHT * 0.5 - CONTAINER_H * 0.5,CONTAINER_W, CONTAINER_H)];
        containerView.layer.cornerRadius = 5;
        containerView.clipsToBounds = YES;
        containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:containerView];

        UILabel *titleTipsLable = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_ADJUST_WIDTH(20),
                                                                            CONTAINER_W,SCREEN_ADJUST_WIDTH(30))];
        titleTipsLable.textAlignment = NSTextAlignmentCenter;
        titleTipsLable.font = [UIFont boldSystemFontOfSize:16];
        titleTipsLable.adjustsFontSizeToFitWidth = YES;
        [containerView addSubview:titleTipsLable];
        _titleTipsLable = titleTipsLable;
        
        UILabel *introTipsLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_ADJUST_WIDTH(36), CGRectGetMaxY(_titleTipsLable.frame) + 20,CONTAINER_W - SCREEN_ADJUST_WIDTH(36) * 2, SCREEN_ADJUST_WIDTH(40))];
        introTipsLable.textAlignment = NSTextAlignmentCenter;
        introTipsLable.font = [UIFont systemFontOfSize:14];
        introTipsLable.textColor = [UIColor grayColor];
        introTipsLable.numberOfLines = 0;
        introTipsLable.adjustsFontSizeToFitWidth = YES;
        [containerView addSubview:introTipsLable];
        //introTipsLable.backgroundColor = COLOR_RANDOM;
        _introTipsLable = introTipsLable;
        if (leftButtonTitle && rightButtonTitle) {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.frame = CGRectMake(introTipsLable.yx_x, containerView.yx_height - CLOSEBTN_H, introTipsLable.yx_width * 0.5, CLOSEBTN_H);
            leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:leftButton];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(leftButton.yx_right, leftButton.yx_y, introTipsLable.yx_width * 0.5, CLOSEBTN_H);
            rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:rightButton];
            
        } else if (leftButtonTitle) {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.frame = CGRectMake(0, containerView.yx_height - CLOSEBTN_H, CONTAINER_W, CLOSEBTN_H);
            leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:leftButton];
            
        } else if (rightButtonTitle) {
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame = CGRectMake(0, containerView.yx_height - CLOSEBTN_H, CONTAINER_W, CLOSEBTN_H);
            rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:rightButton];
        }
    }
    return self;
}

- (void)leftButtonAction {
    [self removeFromSuperview];
    if (self.ltButtonBlock) {
        self.ltButtonBlock();
    }
}

- (void)rightButtonAction {
    [self removeFromSuperview];
    if (self.rtButtonBlock) {
        self.rtButtonBlock();
    }
}

- (void)setTitleTipsLableText:(NSString *)text {
    _titleTipsLable.text = text;
}

- (void)setIntroTipsLableText:(NSString *)text {
    _introTipsLable.text = text;
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
