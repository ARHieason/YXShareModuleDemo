//
//  UIView+Frame.h
//  yixun
//
//  Created by 郭伟林 on 16/8/31.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

#define  StatusBarHeight      20.f
#define  NavigationBarHeight  44.f
#define  TabbarHeight         49.f

@property (nonatomic, assign) CGFloat yx_x;
@property (nonatomic, assign) CGFloat yx_y;
@property (nonatomic, assign) CGFloat yx_width;
@property (nonatomic, assign) CGFloat yx_height;
@property (nonatomic, assign) CGFloat yx_centerX;
@property (nonatomic, assign) CGFloat yx_centerY;
@property (nonatomic, assign) CGPoint yx_origin;
@property (nonatomic, assign) CGSize  yx_size;

@property (nonatomic, assign) CGFloat yx_top;
@property (nonatomic, assign) CGFloat yx_left;
@property (nonatomic, assign) CGFloat yx_bottom;
@property (nonatomic, assign) CGFloat yx_right;


@end
