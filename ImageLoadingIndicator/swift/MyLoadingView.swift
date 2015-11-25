//
//  MyLoadingView.swift
//  ImageLoadingIndicator
//
//  Created by lzy on 15/11/18.
//  Copyright © 2015年 lzy. All rights reserved.
//

import UIKit

let π : CGFloat = CGFloat(M_PI)

let circlePathFillColor = UIColor.clearColor().CGColor
let circlePathStrokeColor = UIColor(red: 207/255.0, green: 207/255.0, blue: 207/255.0, alpha: 1.0).CGColor

class MyLoadingView: UIView {
    
    let circlePathLayer = CAShapeLayer()
    let circleRadius : CGFloat = 40.0
    
    let backgroundLayer = CALayer()
    
    var progress: CGFloat {
        get { return self.circlePathLayer.strokeEnd }
        set {
            if(newValue < 0){
                self.circlePathLayer.strokeEnd = 0
            }else if(newValue > 1) {
                self.circlePathLayer.strokeEnd = 1
            }else {
                self.circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureLayout()
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        self.backgroundColor = UIColor.whiteColor()
        self.circlePathLayer.frame = bounds
        self.circlePathLayer.lineWidth = 2
        self.circlePathLayer.fillColor = circlePathFillColor
        self.circlePathLayer.strokeColor = circlePathStrokeColor
        self.layer.addSublayer(circlePathLayer)
        
        self.backgroundLayer.contents = UIImage(named: "dolphin")?.CGImage
        self.layer.addSublayer(self.backgroundLayer)
        
        self.progress = 0
    }
    
    //改变LoaderView的frame的时候，更新layer的frame(实现layer尺寸根据loaderView自伸缩)
    //同时调用circlePath()方法,触发重新计算path
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.circlePathLayer.frame = bounds
        self.circlePathLayer.path = circlePath().CGPath
        
        let ovalRect = CGRectMake(self.center.x - self.circleRadius, self.center.y - self.circleRadius, 2 * self.circleRadius, 2 * self.circleRadius)
        self.backgroundLayer.frame = CGRectInset(ovalRect, -10, -10)
    }
    
    //圆形循环的Rect
    func circleFrame() -> CGRect {
        var circleFrame = CGRectMake(0, 0, 2 * self.circleRadius, 2 * self.circleRadius)
        circleFrame.origin.x = CGRectGetMidX(self.circlePathLayer.bounds) - self.circleRadius
        circleFrame.origin.y = CGRectGetMidY(self.circlePathLayer.bounds) - self.circleRadius
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
//        return UIBezierPath(ovalInRect: circleFrame())
        let startAngle = -(1/2.0 * π + 1.3/8.0 * π)
        let endAngle = π + 0.9/8.0 * π;
        return UIBezierPath(arcCenter: self.center, radius: self.circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    func finalRadius() -> CGFloat {
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        return sqrt(center.x * center.x + center.y * center.y)
        //矩形的对角线长
    }
    
    func finalRect() -> CGRect {
        let radiusInset = finalRadius() - self.circleRadius
        return CGRectInset(self.circleFrame(), -radiusInset, -radiusInset)
    }
    
    //揭示图片
    func showImage() {
        backgroundColor = UIColor.clearColor()
        progress = 1
        
        //使用strokeEnd属性来移除任何待定的implicit animations，否则干扰reveal animation
        self.circlePathLayer.removeAnimationForKey("strokeEnd")
        
        //移除圈圈进度条
        self.circlePathLayer.removeFromSuperlayer()
        self.backgroundLayer.removeFromSuperlayer()
        
        self.circlePathLayer.fillColor = circlePathStrokeColor
        
        //让圈圈成为显示图片view主layer的mark
        self.superview?.layer.mask = self.circlePathLayer
        
        let beginPath = self.circlePathLayer.path
        //最后外面圆的path
        let finalPath = UIBezierPath(ovalInRect: finalRect()).CGPath
        
        CATransaction.begin()
        //设置kCATransactionDisableActions的valu为true, 来禁用layer的implicit animations
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        //完全显示底层照片
        self.circlePathLayer.path = finalPath
        CATransaction.commit()

        
        
        
        
        
        let animationGroup = CAAnimationGroup()
        
        
        
        
        let alphaAnimation = CABasicAnimation(keyPath: "fillColor")
        
        //为Layer添加Animation
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.delegate = self
        pathAnimation.fromValue = beginPath
        pathAnimation.toValue = finalPath
        pathAnimation.duration = 1
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.circlePathLayer.addAnimation(pathAnimation, forKey: "showImage")
        
        
        animationGroup.animations = [alphaAnimation, pathAnimation]
        animationGroup.duration = 3
        
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.superview?.layer.mask = nil;
    }
    
    
    
    
    
    
    
    /*version 2
    //揭示图片
    func showImage() {
        backgroundColor = UIColor.clearColor()
        progress = 1
        
        //使用strokeEnd属性来移除任何待定的implicit animations，否则干扰reveal animation
        self.circlePathLayer.removeAnimationForKey("strokeEnd")
        
        //移除圈圈进度条
        self.circlePathLayer.removeFromSuperlayer()
        self.backgroundLayer.removeFromSuperlayer()
        
        //让圈圈成为显示图片view主layer的mark
        self.superview?.layer.mask = self.circlePathLayer
        
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        //矩形的对角线长
        let finalRadius = sqrt(center.x * center.x + center.y * center.y)
        
        let radiusInset = finalRadius - self.circleRadius
        //最终圆的Rect
        let outerRect = CGRectInset(self.circleFrame(), -radiusInset, -radiusInset)
        //最后外面圆的path
        let toPath = UIBezierPath(ovalInRect: outerRect).CGPath
        
        let fromPath = self.circlePathLayer.path
        let fromLineWidth = self.circlePathLayer.lineWidth
        
        CATransaction.begin()
        //设置kCATransactionDisableActions的valu为true, 来禁用layer的implicit animations
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        //最终lineWidth等于最终圆半径的两倍,完全显示底层照片
        self.circlePathLayer.lineWidth = 2 * finalRadius
        self.circlePathLayer.path = toPath
        CATransaction.commit()
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = fromLineWidth
        lineWidthAnimation.toValue = 2 * finalRadius
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPath
        
        //为Layer添加Animation(group方式)
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        groupAnimation.animations = [pathAnimation, lineWidthAnimation]
        groupAnimation.delegate = self
        self.circlePathLayer.addAnimation(groupAnimation, forKey: "strokeWidth")
    }
    */
    
    
    
    
}
