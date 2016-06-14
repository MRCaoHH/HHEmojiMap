//
//  ViewController.swift
//  HHEmojiMap
//
//  Created by xoxo on 16/6/14.
//  Copyright © 2016年 caohuihui. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,HHEmojiKeyboardDelegate{
    var keyboard:HHEmojiKeyboard!
    var idLabel:UILabel!
    var idTextView:UITextView!
    var emojiLabel:UILabel!
    var emojiTextView:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dic = HHEmojiManage.getEmojiAll()
        var emojiArr:[String] = []
        for arr in dic.allValues {
            emojiArr = arr as! [String]
            break
        }
        
        //生成map的代码
        //        let emojDic:NSMutableDictionary = NSMutableDictionary()
        //        for emoji in emojiArr {
        //            for ch in emoji.unicodeScalars{
        //                var emojiString = ch.debugDescription as NSString
        //                emojiString = emojiString.stringByReplacingOccurrencesOfString("\"\\u{", withString: "#")
        //                emojiString = emojiString.stringByReplacingOccurrencesOfString("}\"", withString: "")
        //                emojDic.setObject(emoji, forKey: emojiString)
        //
        //            }
        //        }
        //
        //        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        //        path = path.stringByAppendingPathComponent("EmojisMap.plist")
        //        emojDic.writeToFile(path as String, atomically: true)
        
        let width:CGFloat = self.view.frame.size.width
        self.idLabel = UILabel(frame:CGRectMake(0, 20, width, 20))
        self.idLabel.text = "标识字符串"
        self.view.addSubview(self.idLabel)
        
        self.idTextView = UITextView(frame: CGRectMake(0, CGRectGetMaxY(self.idLabel.frame), width, 90))
        self.idTextView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(self.idTextView)
        
        self.emojiLabel = UILabel(frame:CGRectMake(0, CGRectGetMaxY(self.idTextView.frame), width, 20))
        self.emojiLabel.text = "emoji字符串"
        self.view.addSubview(self.emojiLabel)
        
        self.emojiTextView = UITextView(frame: CGRectMake(0, CGRectGetMaxY(self.emojiLabel.frame), width, 90))
        self.emojiTextView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(self.emojiTextView)
        
        let layout = HHCollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsZero
        let frame = CGRectMake(0, CGRectGetMaxY(self.emojiTextView.frame), width, width*3/7)
        self.keyboard = HHEmojiKeyboard(frame: frame, collectionViewLayout: layout, stringArr: emojiArr, isShowDelete: true)
        self.keyboard.emojiKeyboardDelegate = self
        self.keyboard.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.keyboard)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textChange(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     文本改变
     
     - parameter notification: 通知
     */
    func textChange(notification:NSNotification){
        if let textView = notification.object{
            if textView.isEqual(self.idTextView) {
                self.emojiTextView.text = HHEmojiManage.idConvertEmoji(self.idTextView.text)
            }
            
            if textView.isEqual(self.emojiTextView) {
                self.idTextView.text = HHEmojiManage.emojiConvertID(self.emojiTextView.text)
            }
        }
    }
    
    // MARK: - HHEmojiKeyboardDelegate
    func emojiKeyboard(emojiKeyboard:HHEmojiKeyboard,didSelectEmoji emoji:String){
        if self.idTextView.isFirstResponder(){
            self.idTextView.text?.appendContentsOf(emoji)
            let noti = NSNotification.init(name: UITextViewTextDidChangeNotification, object: self.idTextView)
            self.textChange(noti)
        }else{
            self.emojiTextView.text?.appendContentsOf(emoji)
            let noti = NSNotification.init(name: UITextViewTextDidChangeNotification, object: self.emojiTextView)
            self.textChange(noti)
        }
    }
    
    func emojiKeyboardDidSelectDelete(emojiKeyboard:HHEmojiKeyboard){
        if self.idTextView.isFirstResponder(){
            self.idTextView.deleteBackward()
        }else{
            self.emojiTextView.deleteBackward()
        }
    }
    
    func emojiKeyboard(emojiKeyboard: HHEmojiKeyboard, scrollDidTo pageIndex: Int) {
        print(pageIndex)
    }
}

