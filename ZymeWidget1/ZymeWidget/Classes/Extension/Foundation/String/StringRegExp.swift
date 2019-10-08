//
//  StringRegExp.swift
//  Zyme
//
//  Created by Zyme on 16/10/21.
//  Copyright © 2016年 Zyme. All rights reserved.
//

import Foundation

fileprivate extension String {
    
    var isPhoneNumber: Bool {
        get{
            return checkPhoneNumber()
            
        }
    }
    var isEmail: Bool {
        get{
            return checkEmail()
        }
    }
    
    var isIDCard: Bool {
        get{
            return checkCard()
        }
    }
    
    var isNumber: Bool{
        get{
            return checkNumber()
        }
    }
    

}


fileprivate extension String {
    
    func checkNumber()->Bool{
        
        guard self.count > 0 else{
            return false
        }
        let pattern = "^[1-9]\\d*$"
        return self.regExpWithPattern(pattern)
        
    }
    
    func checkPhoneNumber()->Bool {
        
        if self.count != 11 {
            return false
        }
        /*
         *
         * 移动：134、135、136、137、138、139、150、151、157(TD)、158、159、187、188
         * 联通：130、131、132、152、155、156、185、186 电信：133、153、180、189、（1349卫通）
         * 总结起来就是第一位必定为1，第二位必定为3或5或7或8，其他位置的可以为0-9
         *
         *  let telRegex = "[1][3578]\\d{9}";// "[1]"代表第1位为数字1，"[3578]"代表第二位可以为3、5、7、8中的一个，"\\d{9}"代表后面是可以是0～9的数字，有9位。
         */
        
        let pattern = "[1][3578]\\d{9}"
        return self.regExpWithPattern(pattern)
    }
    
    // mark: 验证邮箱
    func checkEmail()-> Bool {
        let pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        return self.regExpWithPattern(pattern)
    }
    
    func checkCard() ->Bool {
        
        if  self.count != 18{
            return false
        }
        
        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return self.regExpWithPattern(pattern)
    }
    //    func isValidIDCard() -> Bool {
    //        if count(self) != 18 {
    //            return false
    //        }
    //
    //        let mmdd = "(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))"
    //        let leapMmdd = "0229"
    //        let year = "(19|20)[0-9]{2}"
    //        let leapYear = "(19|20)(0[48]|[2468][048]|[13579][26])"
    //        let yearMmdd = year + mmdd
    //        let leapyearMmdd = leapYear + leapMmdd
    //        let yyyyMmdd = "((\(yearMmdd))|(\(leapyearMmdd))|(20000229))"
    //        let area = "(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}"
    //        let regex = "\(area)\(yyyyMmdd)[0-9]{3}[0-9Xx]"
    //
    //        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    //
    //        if predicate.evaluateWithObject(self) == false {
    //            return false
    //        }
    //
    //        // Swift 2.0 pls change to Array(self.characters)
    //        let chars = Array(arrayLiteral: self.characters)
    //
    //        let summary: Int = (chars[0].toInt()! + chars[10].toInt()!) * 7
    //            + (chars[1].toInt()! + chars[11].toInt()!) * 9
    //            + (chars[2].toInt()! + chars[12].toInt()!) * 10
    //            + (chars[3].toInt()! + chars[13].toInt()!) * 5
    //            + (chars[4].toInt()! + chars[14].toInt()!) * 8
    //            + (chars[5].toInt()! + chars[15].toInt()!) * 4
    //            + (chars[6].toInt()! + chars[16].toInt()!) * 2
    //            + chars[7].toInt()!
    //            + chars[8].toInt()! * 6
    //            + chars[9].toInt()! * 3
    //
    //        let remainder = summary % 11
    //        let checkString = "10X98765432"
    //
    //        let checkBit = Array(arrayLiteral: checkString)[remainder]
    //
    //        return (checkBit == chars.last)
    //    }
    
    
    /**
     1. 返回所有匹配结果的集合(适合,从一段字符串中提取我们想要匹配的所有数据)
     *  - (NSArray *)matchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;
     2. 返回正确匹配的个数(通过等于0,来验证邮箱,电话什么的,代替NSPredicate)
     *  - (NSUInteger)numberOfMatchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;
     3. 返回第一个匹配的结果。注意，匹配的结果保存在  NSTextCheckingResult 类型中
     *  - (NSTextCheckingResult *)firstMatchInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;
     4. 返回第一个正确匹配结果字符串的NSRange
     *  - (NSRange)rangeOfFirstMatchInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;
     5. block方法
     *  - (void)enumerateMatchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range usingBlock:(void (^)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop))block;
     */
    
    /**
     *  enum {
     NSRegularExpressionCaseInsensitive			 = 1 << 0,   // 不区分大小写的
     NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1,   // 忽略空格和# -
     NSRegularExpressionIgnoreMetacharacters		= 1 << 2,   // 整体化
     NSRegularExpressionDotMatchesLineSeparators	= 1 << 3,   // 匹配任何字符，包括行分隔符
     NSRegularExpressionAnchorsMatchLines		   = 1 << 4,   // 允许^和$在匹配的开始和结束行
     NSRegularExpressionUseUnixLineSeparators	   = 1 << 5,   // (查找范围为整个的话无效)
     NSRegularExpressionUseUnicodeWordBoundaries	= 1 << 6	// (查找范围为整个的话无效)
     
     **/
    
    /**下面2个枚举貌似都没什么意义,除了在block方法中,一般情况下,直接给0吧
     *  enum {
     NSMatchingReportProgress         = 1 << 0,
     NSMatchingReportCompletion       = 1 << 1,
     NSMatchingAnchored               = 1 << 2,
     NSMatchingWithTransparentBounds  = 1 << 3,
     NSMatchingWithoutAnchoringBounds = 1 << 4
     };
     typedef NSUInteger NSMatchingOptions;
     */
    func regExpWithPattern(_ pattern: String!)->Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    
    func isTelNumber()->Bool{
        
        if self.count != 11 {
            return false
        }
        
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700
         */
        
        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        
        let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        /**
         * 中国联通：China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        /**
         * 中国电信：China Telecom
         * 133,153,180,181,189,177,1700
         */
        let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true))
        {
            return true
        } else {
            return false
        }
    }
}

extension Character {
    func toInt() -> Int? {
        return Int(String(self))
    }
}

