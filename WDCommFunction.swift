//
//  WDCommFunction.swift
//  xmksBg
//
//  Created by apple on 2017/3/7.
//  Copyright © 2017年 zhoutai. All rights reserved.
//

import UIKit

class WDCommFunction: NSObject {

   class func getCurrentDate()->String {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        var month = ""
        if comps.month! < 10 {
            month = "0\(comps.month!)"
        }else{
            month = "\(comps.month!)"
        }
        let date = "\(comps.year!)\(month)"
        return date
    }
    
    class func checkCameraPermisson()->Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }else {
            return true
        }
    }
    
}
