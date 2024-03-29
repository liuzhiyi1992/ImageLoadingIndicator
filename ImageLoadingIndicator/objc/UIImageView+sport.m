//
//  UIImageView+sport.m
//  ImageLoadingIndicator
//
//  Created by lzy on 15/11/20.
//  Copyright © 2015年 lzy. All rights reserved.
//

#import "UIImageView+sport.h"

CGFloat const π = M_PI;

#define LINE_WIDTH_CIRCLE_PATH      3

#define FILL_COLOR_CIRCLE_PATH      [UIColor clearColor].CGColor
#define STROKE_COLOR_CIRCLE_PATH    [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0].CGColor

#define RADIUS_LOADING_CIRCLE       40

#define LOADING_START_ANGLE         -(1/2.0 * π + 1.3/8.0 * π)
#define LOADING_END_ANGLE           π + 0.9/8.0 * π

@implementation UIImageView (sport)



- (void)sp_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    
    CircleLoaderIndicator *loader = [[CircleLoaderIndicator alloc] init];
    loader.frame = self.bounds;
    loader.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:loader];
    
    __unsafe_unretained CircleLoaderIndicator *weakLoader = loader;
    [self sd_setImageWithURL:url placeholderImage:placeholderImage options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [weakLoader setProgress:((receivedSize/1.0) / (expectedSize/1.0))];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakLoader showImage];
    }];
    
    
    
}

@end





@interface CircleLoaderIndicator()
@property (strong, nonatomic) CAShapeLayer *circlePathLayer;
@property (assign, nonatomic) CGRect loadingCircleRect;
@property (assign, nonatomic) CGFloat loadingCircleRadius;
@property (strong, nonatomic) CALayer *backgroundLayer;
@end


@implementation CircleLoaderIndicator

- (instancetype)init {
    self = [super init];
    if(self) {
        [self configure];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    if(progress > 1) {
        self.circlePathLayer.strokeEnd = 1;
    }else if(progress < 0) {
        self.circlePathLayer.strokeEnd = 0;
    }else {
        self.circlePathLayer.strokeEnd = progress;
    }
}

- (CGFloat)progress {
    return self.circlePathLayer.strokeEnd;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.circlePathLayer.frame = self.bounds;
    self.loadingCircleRect = CGRectMake(self.center.x - self.loadingCircleRadius, self.center.y - self.loadingCircleRadius, 2 * self.loadingCircleRadius, 2 * self.loadingCircleRadius);
    
    self.circlePathLayer.path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.loadingCircleRadius startAngle:LOADING_START_ANGLE endAngle:LOADING_END_ANGLE clockwise:YES].CGPath;
    self.backgroundLayer.frame = CGRectInset(self.loadingCircleRect, -10, -10);
}

- (void)configure {
    self.backgroundColor = [UIColor whiteColor];
    
    self.loadingCircleRadius = RADIUS_LOADING_CIRCLE;
    
    //shapePathLayer
    self.circlePathLayer = [[CAShapeLayer alloc] init];
    self.circlePathLayer.frame = self.bounds;
    self.circlePathLayer.lineWidth = LINE_WIDTH_CIRCLE_PATH;
    self.circlePathLayer.fillColor = FILL_COLOR_CIRCLE_PATH;
    self.circlePathLayer.strokeColor = STROKE_COLOR_CIRCLE_PATH;
    [self.layer addSublayer:self.circlePathLayer];
    
    //背景Layer
    self.backgroundLayer = [CALayer layer];
    self.backgroundLayer.contents = (id)[UIImage imageNamed:@"dolphin"].CGImage;
    [self.layer addSublayer:self.backgroundLayer];
    
    self.progress = 0;
}

- (void)showImage {
    NSLog(@"show image hh");
    
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

@end






