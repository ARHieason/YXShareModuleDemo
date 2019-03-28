//
//  UIView+Frame.m
//  yixun
//
//  Created by 郭伟林 on 16/8/31.
//  Copyright © 2016年 again. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)yx_x
{
    return self.frame.origin.x;
}

- (void)setYx_x:(CGFloat)yx_x
{
    CGRect frame = self.frame;
    frame.origin.x = yx_x;
    self.frame = frame;
}

- (CGFloat)yx_y
{
    return self.frame.origin.y;
}

- (void)setYx_y:(CGFloat)yx_y
{
    CGRect frame = self.frame;
    frame.origin.y = yx_y;
    self.frame = frame;
}

- (CGFloat)yx_width
{
    return self.frame.size.width;
}

- (void)setYx_width:(CGFloat)yx_width
{
    CGRect frame = self.frame;
    frame.size.width = yx_width;
    self.frame = frame;
}

- (CGFloat)yx_height
{
    return self.frame.size.height;
}

- (void)setYx_height:(CGFloat)yx_height
{
    CGRect frame = self.frame;
    frame.size.height = yx_height;
    self.frame = frame;
}

- (CGFloat)yx_centerX
{
    return self.center.x;
}

- (void)setYx_centerX:(CGFloat)yx_centerX
{
    CGPoint center = self.center;
    center.x = yx_centerX;
    self.center = center;
}

- (CGFloat)yx_centerY
{
    return self.center.y;
}

- (void)setYx_centerY:(CGFloat)yx_centerY
{
    CGPoint center = self.center;
    center.y = yx_centerY;
    self.center = center;
}

- (CGPoint)yx_origin
{
    return self.frame.origin;
}

- (void)setYx_origin:(CGPoint)yx_origin
{
    CGRect frame = self.frame;
    frame.origin = yx_origin;
    self.frame = frame;
}

- (CGSize)yx_size
{
    return self.frame.size;
}

- (void)setYx_size:(CGSize)yx_size
{
    CGRect frame = self.frame;
    frame.size = yx_size;
    self.frame = frame;
}

#pragma mark - Extension

- (CGFloat)yx_top
{
    return self.yx_y;
}

- (void)setYx_top:(CGFloat)yx_top
{
    [self setYx_y:yx_top];
}

- (CGFloat)yx_left
{
    return self.yx_x;
}

- (void)setYx_left:(CGFloat)yx_left
{
    [self setYx_x:yx_left];
}

- (CGFloat)yx_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setYx_bottom:(CGFloat)yx_bottom
{
    [self setYx_y:(yx_bottom - self.yx_height)];
}

- (CGFloat)yx_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setYx_right:(CGFloat)yx_right
{
    [self setYx_x:(yx_right - self.yx_width)];
}

@end
