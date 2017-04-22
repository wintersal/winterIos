//
//  NSString+WD.swift
//  xmksBg
//
//  Created by apple on 2017/1/17.
//  Copyright © 2017年 zhoutai. All rights reserved.
//

import UIKit

/*
 - (NSString *)encrypt:(NSString *)pwd
 {
 NSString *yzMd5 = [self md5:@"yz_"];
 NSString *front = [yzMd5 substringToIndex:12];
 NSString *pwdMd5 = [self md5:pwd];
 NSString *back = [yzMd5 substringFromIndex:(yzMd5.length - 4)];
 return [NSString stringWithFormat:@"%@%@%@",front, pwdMd5, back];
 
 }
 */

extension String{
    
    func randomMD5() -> String {
        let cString = self.cString(using: String.Encoding.utf8)
        let length = CUnsignedInt(
            self.lengthOfBytes(using: String.Encoding.utf8)
        )
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cString!,length,result)
        return String(format:"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],
                      result[9],result[10],result[11],result[12],result[13],result[14],result[15])
    }
    
    
    func encrypt() -> String {
        let yzMd5:String = "yz_".randomMD5()
        let index = yzMd5.index(yzMd5.startIndex, offsetBy: 12)
        let front = yzMd5.substring(to: index)
        let pwdMd5 = self.randomMD5()
        let backIndex = yzMd5.index(pwdMd5.endIndex, offsetBy: -4)
        let back = yzMd5.substring(from: backIndex)
        return "\(front)\(pwdMd5)\(back)"
    }
    
    func isNumber()->Bool //13 14 15 17 18
    {
        //        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{9}$"
        //        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        //        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        //        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let mobile = "^1\\d{10}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        //        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        //        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        //        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        //            || (regextestcm.evaluate(with: self)  == true)
        //            || (regextestct.evaluate(with: self) == true)
        //            || (regextestcu.evaluate(with: self) == true)
        if (regextestmobile.evaluate(with: self))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    func isTelePhone() ->Bool {
        let telePhone = "^0\\d{10,11}"
        let regrexTelePhone = NSPredicate.init(format: "SELF MATCHES %@", telePhone)
        if (regrexTelePhone.evaluate(with: self))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isTakeCode() ->Bool {
        let takeCode = "^\\d{6}"
        let regextestTakeCode = NSPredicate(format: "SELF MATCHES %@",takeCode)
        if regextestTakeCode.evaluate(with: self) == true {
            return true
        }else{
            return false
        }
    }
    
    func isCode() ->Bool {
        let Code = "^\\d{1,6}"
        let regextestCode = NSPredicate(format: "SELF MATCHES %@",Code)
        if regextestCode.evaluate(with: self) == true {
            return true
        }else{
            return false
        }
    }
    
    func isNickName() -> Bool{
        let name = "[A-Za-z0-9\\u4e00-\\u9fa5\\(\\)\\-\\:]{1,16}$"
        let regexName = NSPredicate.init(format: "SELF MATCHES %@", name)
        if regexName.evaluate(with: self) == true{
            return true
        }else{
            return false
        }
    }
    
    func checkUserInfo()->Bool {
        let UserInfo = "[A-Za-z0-9\\u4e00-\\u9fa5\\s]{1,16}$"
        let regexUserInfo = NSPredicate.init(format: "SELF MATCHES %@", UserInfo)
        if regexUserInfo.evaluate(with: self) == true{
            return true
        }else{
            return false
        }
    }
    
    func checkModify() -> Bool {
        let modify = "[A-Za-z0-9\\u4e00-\\u9fa5\\(\\)\\-\\:]{1,32}$"
        let regexModify = NSPredicate.init(format: "SELF MATCHES %@", modify)
        if regexModify.evaluate(with: self) == true{
            return true
        }else{
            return false
        }
    }
    
    func isMailNo() ->Bool{
        let mailNo = "^[a-zA-Z0-9]{1}[a-zA-Z0-9\\-]{8,24}$"
        let regextestMailNo = NSPredicate.init(format: "SELF MATCHES %@", mailNo)
        if regextestMailNo.evaluate(with: self) == true {
            return true
        }else{
            return false
        }
    }
    
    //    func isSpecialCharacter() ->Bool {
    //        let str = "`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#¥%⋯⋯&*（）——+|{}【】‘；：”“’。，_ 、？"
    //        let regex = NSPredicate.init(format: "SELF MATCHES", str)
    //        let arr = Array(str.characters)
    //        var isSuccess:Bool? = false
    //        for item in arr {
    //            if str.contains(item){
    //                isSuccess = true
    //            }else{
    //                isSuccess = false
    //            }
    //        }
    //        return isSuccess!
    //    }
    
    
}
