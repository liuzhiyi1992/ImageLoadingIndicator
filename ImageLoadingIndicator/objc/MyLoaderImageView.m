//
//  LoaderImageView.m
//  ImageLoadingIndicator
//
//  Created by lzy on 15/11/18.
//  Copyright © 2015年 lzy. All rights reserved.
//

#import "MyLoaderImageView.h"
#import "CircleLoadingView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+sport.h"

@interface MyLoaderImageView()

@property (strong, nonatomic) NSURL *imageUrl;

@end


@implementation MyLoaderImageView

- (void)awakeFromNib {
    [self configure];
}

- (instancetype)initWithUrl:(NSURL *)url {
    self = [super init];
    if(self) {
        self.imageUrl = url;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self configure];
    }
    return self;
}

/*
- (void)configureTwo{
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.quyundong.com/uploads/1080_1920.jpg"];
    
    [self sp_setImageWithUrl:url placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //        [weakLoadingView setProgress:((receivedSize/1.0) / (expectedSize/1.0))];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        [weakLoadingView showImage];
    }];
    
}
*/
- (void)configure {
    self.backgroundColor = [UIColor whiteColor];
    CircleLoadingView *loadingView = [[CircleLoadingView alloc] init];
    loadingView.frame = self.bounds;
    [self addSubview:loadingView];
    
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.quyundong.com/uploads/1080_1920.jpg"];
    
    __unsafe_unretained CircleLoadingView *weakLoadingView = loadingView;
    
    
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [weakLoadingView setProgress:((receivedSize/1.0) / (expectedSize/1.0))];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakLoadingView showImage];
    }];
}



@end



