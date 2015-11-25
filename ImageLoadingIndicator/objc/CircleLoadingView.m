//
//  CircleLoadingView.m
//  ImageLoadingIndicator
//
//  Created by lzy on 15/11/18.
//  Copyright © 2015年 lzy. All rights reserved.
//

#import "CircleLoadingView.h"

#define LINE_WIDTH_CIRCLE_PATH      3

#define FILL_COLOR_CIRCLE_PATH      [UIColor clearColor].CGColor
#define STROKE_COLOR_CIRCLE_PATH    [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0].CGColor

#define RADIUS_LOADING_CIRCLE       40

CGFloat const π = M_PI;

@interface CircleLoadingView()

@property (assign, nonatomic) CGFloat loadingCircleRadius;
@property (strong, nonatomic) CALayer *backgroundLayer;
@property (assign, nonatomic) CGRect loadingCircleRect;

@end


@implementation CircleLoadingView

- (instancetype)init {
    self = [super init];
    if(self) {
        [self configure];
    }
    return self;
}

#pragma mark override
//frame改变后，需要更新circlePathLayer的frame和path
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //更新frame
    self.circlePathLayer.frame = self.bounds;
    //更新path
    //进度圈的rect
    self.loadingCircleRect = CGRectMake(self.center.x - self.loadingCircleRadius, self.center.y - self.loadingCircleRadius, 2 * self.loadingCircleRadius, 2 * self.loadingCircleRadius);
    //圆
    //    self.circlePathLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.loadingCircleRect].CGPath;
    //圆弧
    CGFloat startAngle = -(1/2.0 * π + 1.3/8.0 * π);
    CGFloat endAngle = π + 0.9/8.0 * π;
    self.circlePathLayer.path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.loadingCircleRadius startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
    self.backgroundLayer.frame = CGRectInset(self.loadingCircleRect, -10, -10);
}

- (void)configure {
    self.backgroundColor = [UIColor whiteColor];
    
    self.circlePathLayer = [[CAShapeLayer alloc] init];
    self.circlePathLayer.frame = self.bounds;
    self.circlePathLayer.lineWidth = LINE_WIDTH_CIRCLE_PATH;
    self.circlePathLayer.fillColor = FILL_COLOR_CIRCLE_PATH;
    self.circlePathLayer.strokeColor = STROKE_COLOR_CIRCLE_PATH;
    
    self.loadingCircleRadius = RADIUS_LOADING_CIRCLE;
    
    [self.layer addSublayer:self.circlePathLayer];
    self.progress = 0;
    
    //背景图层
    self.backgroundLayer = [CALayer layer];
    self.backgroundLayer.contents = (id)[UIImage imageNamed:@"dolphin"].CGImage;
    [self.layer addSublayer:self.backgroundLayer];
}

- (void)showImage {
    self.backgroundColor = [UIColor clearColor];
    
    self.progress = 1;
    
    [self.circlePathLayer removeAnimationForKey:@"strokeEnd"];
    
    [self.circlePathLayer removeFromSuperlayer];
    [self.backgroundLayer removeFromSuperlayer];
    
    self.circlePathLayer.fillColor = STROKE_COLOR_CIRCLE_PATH;
    self.superview.layer.mask = self.circlePathLayer;
    
    //计算动画最终path
    CGFloat finalRadius = 0.5 * sqrt(self.bounds.size.width * self.bounds.size.width + self.bounds.size.height * self.bounds.size.height);
    CGFloat radiusInset = finalRadius - self.loadingCircleRadius;
    CGRect finalRect = CGRectInset(self.loadingCircleRect, -radiusInset, -radiusInset);
    
    const struct CGPath *beginPath = self.circlePathLayer.path;
    const struct CGPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:finalRect].CGPath;
    
    //------------------------------------------------
    [CATransaction begin];
    //关闭隐式动画
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.circlePathLayer.path = finalPath;
    [CATransaction commit];
    //------------------------------------------------
    
    CABasicAnimation *pathAnimation = [[CABasicAnimation alloc] init];
    [pathAnimation setKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)beginPath;
    pathAnimation.toValue = (__bridge id)finalPath;
    
    pathAnimation.duration = 2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    pathAnimation.delegate = self;
    [self.circlePathLayer addAnimation:pathAnimation forKey:@"showImage"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.superview.layer.mask = nil;
}

#pragma mark 重写progress的get，set方法
//直接对strokeEnd操作，没必要做存储
- (void)setProgress:(CGFloat)progress {
    //    self.progress = progress;
    if(progress < 0) {
        self.circlePathLayer.strokeEnd = 0;
    }else if(progress > 1) {
        self.circlePathLayer.strokeEnd = 1;
    }else {
        self.circlePathLayer.strokeEnd = progress;
    }
}

- (CGFloat)progress {
    return self.circlePathLayer.strokeEnd;
}


@end
