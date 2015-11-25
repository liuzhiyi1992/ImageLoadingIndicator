//
//  CircleLoadingView.h
//  ImageLoadingIndicator
//
//  Created by lzy on 15/11/18.
//  Copyright © 2015年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLoadingView : UIView


@property (strong, nonatomic) CAShapeLayer *circlePathLayer;
@property (assign, nonatomic) CGFloat progress;//直接操作strokeEnd

- (void)showImage;

@end
