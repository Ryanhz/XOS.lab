//
//  StringExtension.swift
//  Zyme
//
//  Created by Zyme on 2017/11/1.
//  Copyright © 2017年 Zyme. All rights reserved.
//

import UIKit
import CommonCrypto

extension String: ZymeNamespaceWrappable {}
// MARK: -subString
extension ZymeNamespaceWrapper where T == String {
    
    public func match(regex: String) ->Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regex])
        return pred.evaluate(with: wrappedValue)
    }
    
    public func index(by: Int) -> String.Index {
        return wrappedValue.index(wrappedValue.startIndex, offsetBy: by)
    }
    
    public func substring(from: Int) -> String {
       let subSequence =  wrappedValue[index(by: from)...]
        return String(subSequence)
    }
    
    public func substring(to: Int) -> String {
        return String(wrappedValue[..<index(by: to)])
    }
    
    public func substring(with: Range<Int>) -> String {
        let startIndex = index(by: with.lowerBound)
        let endIndex = index(by: with.upperBound)
        return String(wrappedValue[startIndex..<endIndex])
    }
    
    public func substring(with: CountableClosedRange<Int>) -> String {
        let startIndex = index(by: with.lowerBound)
        let endIndex = index(by: with.upperBound)
        return String(wrappedValue[startIndex...endIndex])
    }
}

// MARK: -attributedString
extension ZymeNamespaceWrapper where T == String {
    
    public func attributedString(color: UIColor, size: CGFloat)-> NSAttributedString {
        
        return attributedString(color: color, font: UIFont.systemFont(ofSize: size))
    }
    
    public func mutableAttributedString(color: UIColor, size: CGFloat)-> NSMutableAttributedString{
        return mutableAttributedString(color: color, font: UIFont.systemFont(ofSize: size))
    }
    
    public func attributedString(color: UIColor, font: UIFont)-> NSAttributedString {
        let str = NSAttributedString(string: wrappedValue,
                                     attributes: [NSAttributedString.Key.foregroundColor: color,
                                                  NSAttributedString.Key.font: font]
        )
        return str
    }

    
    public func mutableAttributedString(color: UIColor, font: UIFont)-> NSMutableAttributedString{
        let str = NSMutableAttributedString(string: wrappedValue,
                                            attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        )
        return str
    }

    
}

// MARK: -size
extension ZymeNamespaceWrapper where T == String {
    
    ///富文本的高度
    public func heightWithStringAttributes(_ attributes : [NSAttributedString.Key : Any], fixedWidth : CGFloat) -> CGFloat {
        
        guard wrappedValue.count > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
//        wrappedValue.bo
        let text = wrappedValue as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
    }
    
    /// 文字的高度
    public func heightWithFont(_ font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat) -> CGFloat {
        
        guard wrappedValue.count > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = wrappedValue as NSString
        let rect = text.boundingRect(with: size, options:[.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.height
    }
    
    /// 富文本的宽度
    public func widthWithStringAttributes(_ attributes : [NSAttributedString.Key : Any]) -> CGFloat {
        
        guard wrappedValue.count > 0 else {
            return 0
        }
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = wrappedValue as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.width
    }
    
    ///文字的宽度
    public func widthWithFont(_ font : UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        
        guard wrappedValue.count > 0 else {
            return 0
        }
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = wrappedValue as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.width
    }
}

extension ZymeNamespaceWrapper where T == String {
    
    //去掉首尾空格
    var removeHeadAndTailSpace: String {
        let whitespace = NSCharacterSet.whitespaces
        return wrappedValue.trimmingCharacters(in: whitespace)
    }
    
    //去掉首尾空格 包括后面的换行 \n
    var removeHeadAndTailSpacePro: String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return wrappedValue.trimmingCharacters(in: whitespace)
    }
}

// MARK: _<##>digest and Encoded
extension ZymeNamespaceWrapper where T == String {
    
    /*URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
    URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
    URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
    URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
    URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
    URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
     
     var originalString = "test/test=42"
     var customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}").invertedSet
     var escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
     println("escapedString: \(escapedString)")
     */
    public var urlEncodedString: String {
        let encodeUrlString = wrappedValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? wrappedValue
    }
    
    public var urlDecodedString: String {
        return wrappedValue.removingPercentEncoding ??  wrappedValue
    }
    
    public var md5: String {
        return getMessageDigest(string: wrappedValue, fp: CC_MD5, length: Int(CC_MD5_DIGEST_LENGTH))
    }
    
    public var sha1: String {
        return getMessageDigest(string: wrappedValue, fp: CC_SHA1, length: Int(CC_SHA1_DIGEST_LENGTH))
    }
    private typealias MessageDigestFuncPtr = (_ data: UnsafeRawPointer?, _ len: CC_LONG, _ md: UnsafeMutablePointer<UInt8>?) -> UnsafeMutablePointer<UInt8>?
    
    private func getMessageDigest(string: String, fp: MessageDigestFuncPtr, length: Int)->String {
        let cStr = string.cString(using: .utf8)!
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        
        _ = fp(cStr, CC_LONG(strlen(cStr)), digest)
        
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", digest[i])
        }
        digest.deinitialize(count: 1)
        return String(hash)
    }
}

// MARK: -<##>regExp
extension ZymeNamespaceWrapper where T == String  {
    
    public var isPhoneNumber: Bool { return checkPhoneNumber() }
    
    public var isEmail: Bool { return checkEmail() }
    
    public var isIDCard: Bool { return checkCard() }
    
    public var isNumber: Bool { return checkNumber() }
    
    public var isFigure: Bool { return checkFigure() }

    private func checkUserName()->Bool {
        guard wrappedValue.count > 0 else {
            return false
        }
        //用户名验证（允许使用小写字母、数字、下滑线、横杠，一共3~16个字符）
        let pattern = "^[a-z0-9_-]{3,16}$"
        return self.regExpWithPattern(pattern)
    }
    
    private func checkNumber()->Bool{
        guard wrappedValue.count > 0 else{
            return false
        }
        let pattern = "^[1-9]\\d*$"
        return self.regExpWithPattern(pattern)
    }
    
    private func checkFigure() ->Bool{
        guard wrappedValue.count > 0 else{
            return false
        }
        let pattern = "^[0-9]\\d*$"
        return self.regExpWithPattern(pattern)
    }
    
    private func checkPhoneNumber()->Bool {
        
        if wrappedValue.count != 11 {
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
        //^1[0-9]{10}$
        let pattern = "[1][3578]\\d{9}"
        return self.regExpWithPattern(pattern)
    }
    
    // mark: 验证邮箱
    private func checkEmail()-> Bool {
        let pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        return self.regExpWithPattern(pattern)
    }
    
    private func checkCard() ->Bool {
        
        if  wrappedValue.count != 18{
            return false
        }
        
        let pattern = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return self.regExpWithPattern(pattern)
    }
    
    private func match(_ tagString: String) throws -> [NSRange]  {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: tagString, options: NSRegularExpression.Options.caseInsensitive)
            
            let matches = regex.matches(in: wrappedValue, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, wrappedValue.count))
            
            var ranges = [NSRange]()
            
            for result in matches {
                let range = result.range
                ranges.append(range)
            }
            return ranges
        } catch let error {
            throw error
        }
    }
    
    private func regExpWithPattern(_ pattern: String!)->Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: wrappedValue, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, wrappedValue.count))
            return matches.count > 0
        } catch {
            return false
        }
    }
    
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
     NSRegularExpressionCaseInsensitive             = 1 << 0,   // 不区分大小写的
     NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1,   // 忽略空格和# -
     NSRegularExpressionIgnoreMetacharacters        = 1 << 2,   // 整体化
     NSRegularExpressionDotMatchesLineSeparators    = 1 << 3,   // 匹配任何字符，包括行分隔符
     NSRegularExpressionAnchorsMatchLines           = 1 << 4,   // 允许^和$在匹配的开始和结束行
     NSRegularExpressionUseUnixLineSeparators       = 1 << 5,   // (查找范围为整个的话无效)
     NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6    // (查找范围为整个的话无效)
     
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

    
}

