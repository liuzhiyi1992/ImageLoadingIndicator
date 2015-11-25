//
//  UIImageView+sport.h
//  ImageLoadingIndicator
//
//  Created by lzy on 15/11/20.
//  Copyright © 2015年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (sport)


- (void)sp_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
    
@end




@interface CircleLoaderIndicator : UIView

@property (assign, nonatomic) CGFloat progress;

- (void)showImage;

@end
