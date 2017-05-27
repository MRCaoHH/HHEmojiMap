//
//  HHEmojiManage.swift
//  HHEmojiKeyboard
//
//  Created by xoxo on 16/6/6.
//  Copyright © 2016年 caohuihui. All rights reserved.
//

import Foundation

let HHEmojiMap:NSDictionary = HHEmojiManage.getEmojiMap()

class HHEmojiManage:NSObject {
    
    /**
     得到所有的emoji表情
     
     - returns: emoji表情的字典
     */
    class func getEmojiAll() -> NSDictionary{
        if let path = Bundle.main.path(forResource: "EmojisList", ofType: "plist"){
            if let dic = NSDictionary(contentsOfFile: path as String){
                return dic
            }
        }
       return NSDictionary()
    }
    
    /**
     得到emoji表情的map
     
     - returns: emoji表情的字典
     */
    class func getEmojiMap() -> NSDictionary{
        if let path = Bundle.main.path(forResource: "EmojiMap", ofType: "plist"){
            if let dic = NSDictionary(contentsOfFile: path as String){
                return dic
            }
        }
        return NSDictionary()
    }
    
    /**
     标识转换成emoji表情
     
     - parameter idString: 标识字符串
     */
    class func idConvertEmoji(_ idString:String) -> String{
        var emojiString = idString as NSString
        for key in HHEmojiMap.allKeys {
            if let value = HHEmojiMap.object(forKey: key as! String){
                let withString = value as! String
                emojiString = emojiString.replacingOccurrences(of: key as! String, with: withString) as NSString
                let range = emojiString.range(of: "#")
                if range.length == 0 {
                    break
                }
            }
        
        }
        return emojiString as String
    }
    
    /**
     emoji表情转换成标识
     
     - parameter emojiString: emoji表情字符串
     */
    class func emojiConvertID(_ emojiString:String) -> String{
        var idString = emojiString as NSString
        for value in HHEmojiMap.allValues {
            if let key = HHEmojiMap.allKeys(for: value).first {
                let withString = key as! String
                idString = idString.replacingOccurrences(of: value as! String, with: withString) as NSString
            }
        }
        return idString as String
    }
    
}
