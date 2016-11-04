//
//  TextViewWithButton.swift
//  TextViewWithButton
//
//  Created by Christian Schraga on 11/3/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit

protocol TextViewWithButtonDelegate {
    func textViewButtonClicked(_ view: TextViewWithButton)
    func textViewWithButtonNewHeight(_ view: TextViewWithButton, preferredHeight height: CGFloat)
    func textViewWithButtonEditing(_ view: TextViewWithButton, editing: Bool)
}

class TextViewWithButton: UIView, UITextViewDelegate {
    
    //UI
    internal var textView: UITextView!
    internal var button: UIButton!
    
    //internal attributes
    fileprivate var _lineWidth: CGFloat = 0.0
    fileprivate var _roundedCorners: Bool = false
    fileprivate var _bgColor = UIColor.clear
    fileprivate var _lineColor = UIColor.clear
    fileprivate var _textColor = UIColor.gray
    fileprivate var _font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    fileprivate var _minimumNumberOfLines = 2
    fileprivate var _maximumNumberOfLines = 6
    fileprivate var _defaultText = "What's on your mind?"
    fileprivate var _image = UIImage(named: "submit")
    fileprivate var _cornerRadius: CGFloat = 3.0
    
    //delegate
    var delegate: TextViewWithButtonDelegate?
    
    //public attributes
    var lineWidth: CGFloat {
        get{
            return _lineWidth
        }
        set(new){
            if new == _lineWidth {
                return
            } else if new < 0.0 {
                return
            } else {
                _lineWidth = new
                setNeedsDisplay()
            }
        }
    }
    var roundedCorners: Bool {
        get{
            return _roundedCorners
        }
        set(new){
            _roundedCorners = new
            setNeedsDisplay()
        }
    }
    var bgColor: UIColor {
        get{
            return _bgColor
        }
        set(new){
            _bgColor = new
            setNeedsDisplay()
        }
    }
    var lineColor: UIColor {
        get{
            return _lineColor
        }
        set(new){
            _lineColor = new
            setNeedsDisplay()
        }
    }
    var textColor: UIColor {
        get{
            return _textColor
        }
        set(new){
            _textColor = new
            textView.textColor = _textColor
        }
    }
    var font: UIFont {
        get{
            return _font
        }
        set(new){
            if new != _font{
                _font = new
                textView.font = _font
                delegate?.textViewWithButtonNewHeight(self, preferredHeight: idealHeight)
            }
        }
    }
    var minimumNumberOfLines: Int {
        get{
            return _minimumNumberOfLines
        }
        set(new){
            if new == _minimumNumberOfLines {
                return
            } else if new < 1 {
                print("minimum lines can't be less than 1")
                return
            } else if new > _maximumNumberOfLines {
                print("minimum lines can't be less than maximum")
                return
            } else {
                _minimumNumberOfLines = new
                delegate?.textViewWithButtonNewHeight(self, preferredHeight: idealHeight)
            }
        }
    }
    var maximumNumberOfLines: Int {
        get{
            return _maximumNumberOfLines
        }
        set(new){
            if new == _maximumNumberOfLines {
                return
            } else if new < 1 {
                print("minimum lines can't be less than 1")
                return
            } else if new > _maximumNumberOfLines {
                print("minimum lines can't be less than maximum")
                return
            } else {
                _maximumNumberOfLines = new
                delegate?.textViewWithButtonNewHeight(self, preferredHeight: idealHeight)
            }
        }
    }
    var defaultText: String {
        get{
            return _defaultText
        }
        set(new){
            if new != _defaultText{
                if textView.text == "" || textView.text == _defaultText{
                    textView.text = new
                }
                _defaultText = new
            }
        }
    }
    var buttonImage: UIImage? {
        get{
            return _image
        }
        set(newImage){
            if newImage != nil {
                button.setImage(newImage, for: .normal)
                _image = newImage
            }
            
        }
    }
    var idealHeight: CGFloat {
        get{
            let small = _font.lineHeight * CGFloat(_minimumNumberOfLines)
            let big   = _font.lineHeight * CGFloat(_maximumNumberOfLines)
            let firstPass = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: big)).height
            
            let secondPass = max(firstPass, small)
            let finalPass  = min(secondPass, big)
            
            return finalPass
        }
    }
    var offset: CGFloat {
        get{
            return textView.contentOffset.y
        }
    }
    var atMaxHeight: Bool {
        get {
            let big = _font.lineHeight * CGFloat(_maximumNumberOfLines)
            return idealHeight >= big
        }
    }
    var text: String {
        get{
            return textView.text
        }
    }
    func clear(){
        textView.text = _defaultText
    }
    func resign(){
        textView.resignFirstResponder()
        self.resignFirstResponder()
    }
    
    //lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(){
        super.init(frame: CGRect.zero)
        setup()
    }
    
    //internal helper functions
    internal func setup(){
        //group
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.isUserInteractionEnabled = true
        
        //text view
        textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = defaultText
        textView.font = _font
        textView.textColor = UIColor.gray
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator   = false
        self.addSubview(textView)
        
        //button
        button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "submit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(TextViewWithButton.buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        //constraints
        let h = _font.lineHeight * 1.1
        let seperator: CGFloat = 4.0
        
        let w1 = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: h)
        let h1 = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: h)
        let e1 = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1.0, constant: _lineWidth + seperator)
        let b1 = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1.0, constant: _lineWidth + seperator)
        button.addConstraints([w1, h1])
        self.addConstraints([e1, b1])
        
        let t2 = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: _lineWidth + seperator)
        let l2 = NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: _lineWidth + seperator)
        let e2 = NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1.0, constant: seperator)
        let b2 = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([t2, l2, e2, b2])
        
    }
    
    //selectors
    func buttonPressed(_ button: UIButton){
        print("button pressed")
        if textView.text != _defaultText{
            delegate?.textViewButtonClicked(self)
        }
        textView.endEditing(true)
    }
    
    //text view delegate
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewWithButtonNewHeight(self, preferredHeight: idealHeight)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == _defaultText {
            textView.text = ""
        }
        delegate?.textViewWithButtonEditing(self, editing: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if textView.text == "" {
            textView.text = _defaultText
        }
        delegate?.textViewWithButtonEditing(self, editing: false)
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        let insetRect = rect.insetBy(dx: _lineWidth/2, dy: _lineWidth/2)
        let drawPath = _roundedCorners ? UIBezierPath(roundedRect: insetRect, cornerRadius: _cornerRadius) : UIBezierPath(rect: insetRect)
        ctx.setStrokeColor(_lineColor.cgColor)
        ctx.setFillColor(_bgColor.cgColor)
        ctx.setLineWidth(_lineWidth)
        ctx.addPath(drawPath.cgPath)
        ctx.drawPath(using: .fillStroke)
        
    }
    
    
}
