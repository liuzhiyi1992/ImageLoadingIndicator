//
//  LoaderImageView.swift
//  ImageLoadingIndicator
//
//  Created by lzy on 15/11/18.
//  Copyright © 2015年 lzy. All rights reserved.
//

import UIKit

class LoaderImageView: UIImageView {
    
    let loadingIndicator = MyLoadingView(frame:  CGRectZero)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //进度圈view
        self.addSubview(self.loadingIndicator)
        self.loadingIndicator.frame = self.bounds
        self.loadingIndicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let url = NSURL(string: "http://www.quyundong.com/uploads/1080_1920.jpg")
        self.sd_setImageWithURL(url, placeholderImage: nil, options: .CacheMemoryOnly, progress: {
//            [weak self]
            [unowned self](receivedSize, expectedSize) -> Void in
            self.loadingIndicator.progress = CGFloat(receivedSize)/CGFloat(expectedSize)
            }) {
                [unowned self](image, error, _, _) -> Void in
                self.loadingIndicator.showImage()
        }
    }
}

