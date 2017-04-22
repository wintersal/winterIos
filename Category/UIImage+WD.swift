//
//  UIImage+WD.swift
//  xmksBg
//
//  Created by apple on 2017/1/9.
//  Copyright © 2017年 zhoutai. All rights reserved.
//

import UIKit

extension UIImage{

    class func ImageWithToCirlBorder(borderWith:CGFloat, borderColor:UIColor, image:String)->UIImage {
        let image:UIImage = UIImage.init(named: image)!
        let frame:CGRect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContext(image.size)
        let path:UIBezierPath = UIBezierPath.init(ovalIn: frame)
        path.addClip()
        borderColor.setFill()
        path.fill()
        
        //设置裁剪区域
        let clipPath:UIBezierPath = UIBezierPath.init(ovalIn: CGRect.init(x: frame.origin.x + borderWith, y: frame.origin.y + borderWith, width: frame.size.width - borderWith * 2, height: frame.size.height - borderWith * 2))
        clipPath.addClip()
        
        //绘制图片
        image.draw(at: CGPoint.init(x: 0, y: 0))
        
        //获取最新图片
        let newImg:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImg
    }
    
    class func ImageWithPhoneNumber(image:UIImage)->UIImage{
        let rect:CGRect = CGRect.init(x: 20, y: 0, width: WDW-40, height: 30)
        let path:UIBezierPath = UIBezierPath.init(rect: rect)
        path.addClip()
        image.draw(in: rect)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
