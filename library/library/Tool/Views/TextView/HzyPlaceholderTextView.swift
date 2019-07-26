//
//  HzyPlaceholderTextView.swift
//  DidaSystem
//
//  Created by hzf on 2017/7/13.
//  Copyright © 2017年 feidSoft. All rights reserved.
//

import UIKit

class HzyPlaceholderTextView: UITextView {
    
    var placeholderColor: UIColor = UIColor.gray {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var placeholder: String? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var placeholderFont: UIFont?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override var text: String!{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override var attributedText: NSAttributedString!{
        didSet {
            setNeedsDisplay()
        }
    }
    
    deinit {
        removeTextChangeObserver()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addTextChangeObserver()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTextChangeObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    private func removeTextChangeObserver(){
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private  func addTextChangeObserver(){
        NotificationCenter.default.addObserver(self,selector: #selector(fe_didChange(_:)),name: UITextView.textDidChangeNotification,object: nil)
    }
    
    @objc private func fe_didChange (_ notification: Notification) {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !self.hasText, let placeholder = self.placeholder else {
            return
        }
        
        var attrs = [NSAttributedString.Key: Any]()
        attrs[NSAttributedString.Key.font] = self.placeholderFont ?? self.font
        attrs[NSAttributedString.Key.foregroundColor] = self.placeholderColor
        
        var pRect = rect
        pRect.origin.x = 5
        pRect.origin.y = 8
        pRect.size.width -= pRect.origin.x*2
        pRect.size.height -= pRect.origin.y*2
        
        placeholder.draw(in: pRect, withAttributes: attrs)
    }
}
