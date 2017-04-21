//
//  WDHeader.swift
//  xmksBg
//
//  Created by apple on 2017/1/7.
//  Copyright © 2017年 zhoutai. All rights reserved.
//

import UIKit
import Alamofire
//18252573159  123456 / susul0125 站点:15261459727 123456

let WDThemeColor:UIColor = UIColor.init(red: 255.0/255.0, green: 68.0/255.0, blue: 0, alpha: 1)
let WDGreenColor:UIColor = UIColor.init(red: 0, green: 221.0/255.0, blue: 92.0/255.0, alpha: 1)
let WDBorderColor:UIColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
let WDBgBorderColor:UIColor = UIColor.init(red: 234.0/255.0, green: 234.0/255.0, blue: 234.0/255.0, alpha: 1)
let WDSwitcherBg:UIColor = UIColor.init(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)
let WDViewControllerBg:UIColor = UIColor.init(red: 249.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
let sliderItemSelectedColor:UIColor = UIColor.init(red: 255.0/255.0, green: 193.0/255.0, blue: 170.0/255.0, alpha: 1)
let sannerIndexColor:UIColor = UIColor.init(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
let titleColor:UIColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
let smsTemplateColor:UIColor = UIColor.init(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
let smsTemplateGrayColor:UIColor = UIColor.init(red: 152.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
let timeOut = 10
var manger:SessionManager? = nil
let packageFilePath:String = NSHomeDirectory() + "/Documents/packages.plist"
let marksFilePath:String = NSHomeDirectory() + "/Documents/marks.plist"
let baseUrl = "http://api.84185858.com/index.php?bmxVersion=4.2&bmxSource=ios&buildVersion=30"
let WDW = UIScreen.main.bounds.width
let WDH = UIScreen.main.bounds.height
let WDScale = WDW / 320.0
//let baseUrl = "http://baimixu.f3322.net:8082/index.php?version=3&"
//let baseUrl = "http://baimixu.f3322.net/index.php?"
//let baseUrl = "http://192.168.1.1/index.php?"
//http://baimixu.f3322.net/index.php?
//let baseUrl = "http://baimixu.f3322.net/index.php?"
let qiNiuUrl = "http://api.panda-life.cn/index.php?m=Api&c=Upload&a=GetqiniuToken&token=b27c0e02ae337cd891dcffaec4038029"

func userType() -> String {
    var userType = "0"
    if let type = WDAccountTool.getAccount() as? WDModel4Login {
        userType = type.fUserTypeId
    }
    return userType
}

func getCompanyIcon(companyId:String)->String{
    var companyIcon = ""
    let companyId:Int = Int(companyId)!
    switch companyId {
    case 125://中通
        companyIcon = "stIcon"
        break
    case 109://韵达
        companyIcon = "yundaIcon"
        break
        
    case 108://圆通
        companyIcon = "yuantongIcon"
        break
        
    case 5:////百世汇通
        companyIcon = "baishiIcon"
        break
        
    case 23://ems
        companyIcon = "emsIcon"
        break
        
    case 92://天天
        companyIcon = "tiantianIcon"
        break
        
    case 184://安能
        companyIcon = "annengIcon"
        break
        
    case 183://国通
        companyIcon = "guotongIcon"
        break
        
    case 181://中国邮政/平邮
        companyIcon = "youzhengIcon"
        break
        
    case 77://顺丰
        companyIcon = "shunfengIcon"
        break
        
    case 133://申通快递
        companyIcon = "shentongIcon"
        break
        
    case 182://德邦物流
        companyIcon = "debangIcon"
        break
        
    case 26://凡客如风达
        companyIcon = "rufengdaIcon"
        break
        
    case 34://汇通
        companyIcon = "huitongIcon"
        break
        
    case 178://京东
        companyIcon = "jingdongIcon"
        break
        
    case 53://快捷速递
        companyIcon = "kuaijieIcon"
        break
        
    case 187://门对门
        companyIcon = "d2d"
        break
        
    case 73://全峰快递
        companyIcon = "quanfengIcon"
        break
        
    case 72://全一
        companyIcon = "quanyiIcon"
        break
        
    case 134://其他
        companyIcon = "expresszhanweiIcon"
        break
        
    case 177://如风达
        companyIcon = "rufengdaIcon"
        break
        
    case 75://如风达快递
        companyIcon = "rufengdaIcon"
        break
        
    case 179:// 苏宁易购
        companyIcon = "suningIcon"
        break
        
    case 176:// 晟邦物流
        companyIcon = "shenbangIcon"
        break
        
    case 81://速尔物流
        companyIcon = "suerIcon"
        break
        
    case 186://赛澳递
        companyIcon = "saiaodi"
        break
        
    case 180://唯品会
        companyIcon = "weipinhuiIcon"
        break
        
    case 185://联报万象物流
        companyIcon = "lianbaowanxiang"
        break
        
    case 115://优速物流
        companyIcon = "ucIcon"
        break
        
    case 126://着急送
        companyIcon = "zhaijisongIcon"
        break
    default:
        companyIcon = "expresszhanweiIcon"
    }
    return companyIcon
}

