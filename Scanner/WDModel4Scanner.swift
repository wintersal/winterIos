//
//  WDModel4Scanner.swift
//  xmksBg
//
//  Created by apple on 2017/1/16.
//  Copyright © 2017年 zhoutai. All rights reserved.
//

import UIKit

class WDModel4Scanner: NSObject {

    var mailNo = String()
    var index = String()
    
    init(dict:[String:String]){
        self.mailNo = dict["mailNo"]!
        self.index = dict["index"]!
    }
    
    class func dictArr2modelArr(dictArr:[[String:String]])->[WDModel4Scanner]{
        var models:[WDModel4Scanner] = [WDModel4Scanner]()
        for item:[String:String] in dictArr {
            models.append(WDModel4Scanner.init(dict: item))
        }
        return models
    }
}
