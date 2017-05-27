//
//  ViewController.swift
//  HHEmojiMap
//
//  Created by xoxo on 16/6/14.
//  Copyright © 2016年 caohuihui. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,HHEmojiKeyboardDelegate,UITextViewDelegate{
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
            emojiArr += arr as! [String]
            
        }
        
        let width:CGFloat = self.view.frame.size.width
        self.idLabel = UILabel(frame:CGRect(x: 0, y: 20, width: width, height: 20))
        self.idLabel.text = "标识字符串"
        self.view.addSubview(self.idLabel)
        
        self.idTextView = UITextView(frame: CGRect(x: 0, y: self.idLabel.frame.maxY, width: width, height: 90))
        self.idTextView.delegate = self
        self.idTextView.backgroundColor = UIColor.gray
        self.view.addSubview(self.idTextView)
        
        self.emojiLabel = UILabel(frame:CGRect(x: 0, y: self.idTextView.frame.maxY, width: width, height: 20))
        self.emojiLabel.text = "emoji字符串"
        self.view.addSubview(self.emojiLabel)
        
        self.emojiTextView = UITextView(frame: CGRect(x: 0, y: self.emojiLabel.frame.maxY, width: width, height: 90))
        self.emojiTextView.delegate = self
        self.emojiTextView.backgroundColor = UIColor.gray
        self.view.addSubview(self.emojiTextView)
        
        let layout = HHCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        let frame = CGRect(x: 0, y: self.emojiTextView.frame.maxY, width: width, height: width*3/7)
        self.keyboard = HHEmojiKeyboard(frame: frame, collectionViewLayout: layout, stringArr: emojiArr, isShowDelete: true)
        self.keyboard.emojiKeyboardDelegate = self
        self.keyboard.backgroundColor = UIColor.white
        self.view.addSubview(self.keyboard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        //注意模拟器运行
//        createEmojiMap("/Users/caohuihui/Desktop/1")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createEmojiMap(dirPath:NSString) -> Void {
        //生成map的代码
        let dic = HHEmojiManage.getEmojiAll()
        var emojiArr:[String] = []
        for arr in dic.allValues {
            emojiArr += arr as! [String]
        }
        
        
        let emojDic:NSMutableDictionary = NSMutableDictionary()
        for emoji in emojiArr {
            for ch in emoji.unicodeScalars{
                var emojiString = ch.debugDescription as NSString
                emojiString = emojiString.replacingOccurrences(of: "\"\\u{", with: "#") as NSString
                emojiString = emojiString.replacingOccurrences(of: "}\"", with: "") as NSString
                emojDic.setObject(emoji, forKey: emojiString)
                
            }
        }

        let path:NSString = dirPath.appendingPathComponent("EmojisMap.plist") as NSString
        emojDic.write(toFile: path as String, atomically: true)
    }
    
    /**
     文本改变
     
     - parameter notification: 通知
     */
    func textChange(_ notification:Notification){
        if let textView = notification.object{
            if (textView as AnyObject).isEqual(self.idTextView) {
                self.emojiTextView.text = HHEmojiManage.idConvertEmoji(self.idTextView.text)
            }
            
            if (textView as AnyObject).isEqual(self.emojiTextView) {
                self.idTextView.text = HHEmojiManage.emojiConvertID(self.emojiTextView.text)
            }
        }
    }
    
    // MARK: - HHEmojiKeyboardDelegate
    func emojiKeyboard(_ emojiKeyboard:HHEmojiKeyboard,didSelectEmoji emoji:String){
        if self.idTextView.isFirstResponder{
            self.idTextView.text?.append(emoji)
            let noti = Notification.init(name: NSNotification.Name.UITextViewTextDidChange, object: self.idTextView)
            self.textChange(noti)
        }else{
            self.emojiTextView.text?.append(emoji)
            let noti = Notification.init(name: NSNotification.Name.UITextViewTextDidChange, object: self.emojiTextView)
            self.textChange(noti)
        }
    }
    
    func emojiKeyboardDidSelectDelete(_ emojiKeyboard:HHEmojiKeyboard){
        if self.idTextView.isFirstResponder{
            self.idTextView.deleteBackward()
        }else{
            self.emojiTextView.deleteBackward()
        }
    }
    
    func emojiKeyboard(_ emojiKeyboard: HHEmojiKeyboard, scrollDidTo pageIndex: Int) {
        print(pageIndex)
    }
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

