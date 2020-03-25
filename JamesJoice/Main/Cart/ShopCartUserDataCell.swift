//
//  ShopCartUserDataCell.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 17/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

class ShopCartUserDataCell : UITableViewCell, UITextViewDelegate{
    
    static var radioButtons = Set<UIButton>()
    
    var dictionary : NSMutableDictionary?
    var dictionaryA : NSMutableDictionary?
    var fields : Array<CheckoutField>?{
        didSet{
            populate()
        }
    }
    var placeholders = [UITextView : String]()
    var holding = [UITextView: Bool]()
    var cache = [Any]()
    
    @IBOutlet weak var mCard: UIView!
    @IBOutlet weak var mBody: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mCard.clipsToBounds = true
        mCard.layer.cornerRadius = corners
    }
    
    private func populate(){
        guard let fields = self.fields else { return }
        
        for view in mBody.arrangedSubviews{
            view.removeFromSuperview()
        }
        holding.removeAll()
        for field in fields {
            if let type = field.type, type == "text", let label = field.label{
                if let view = Bundle.main.loadNibNamed("FormTextField", owner: self, options: nil)?[0] as? UIView{
                    let textField = view.viewWithTag(1) as! PaddedTextField
                    textField.textInsets = UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 15)
                           
                    let place  = Utils.setup(attributedString: NSAttributedString.init(string: label))
                    place.addAttribute(NSAttributedString.Key.foregroundColor, value: colorPrimary, range: NSMakeRange(0, place.length))
                    textField.attributedPlaceholder = place
                    if let value = field.value, let stored = prefs?.string(forKey: value){
                        let text = Utils.setup(attributedString: NSAttributedString.init(string: stored))
                        text.addAttribute(NSAttributedString.Key.foregroundColor, value: colorPrimary, range: NSMakeRange(0, place.length))
                        textField.attributedText = text
                    }
                    mBody.addArrangedSubview(view)
                    dictionary?[field] = textField
                    
                    textField.clipsToBounds = true
                    textField.layer.cornerRadius = corners
                }
                
            }else if let type = field.type, type == "textarea", let label = field.label{
                if let view = Bundle.main.loadNibNamed("FormTextArea", owner: self, options: nil)?[0] as? UIView{
                    let textView = view.viewWithTag(1) as! UITextView
                    textView.delegate = self
                    if let value = field.value, let stored = prefs?.string(forKey: value){
                        textView.text = stored
                    }else{
                        textView.text = field.name
                        holding[textView] = field.name != nil
                    }
                    placeholders[textView] = field.name
                    mBody.addArrangedSubview(view)
                    
                    textView.clipsToBounds = true
                    textView.layer.cornerRadius = corners
                    
                    textView.textContainerInset = UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 0);
                    
                    dictionaryA?[field] = textView
                }
            }else if let type = field.type, type == "checkbox"{
                if let view = Bundle.main.loadNibNamed("CheckoutForm", owner: self, options: nil)?[0] as? UIView{
                    let label = view.viewWithTag(1) as! UILabel
                    label.text = field.label
                    let container = view.viewWithTag(2) as! UIStackView
                if let options = field.select{
                    for item in options.values.sorted(){
                if let view = Bundle.main.loadNibNamed("PaymentMethodView", owner: self, options: nil)?[0] as? UIView{
                    let wrapper = CheckoutWrapper.init(view: view, field: field, option: item)
                    self.cache.append( wrapper)
                    container.addArrangedSubview(view)
                }
                    }
                    view.setNeedsLayout()
                    view.layoutIfNeeded()
                   
                }
                    
                    mBody.addArrangedSubview(view)
                   
                }
            }else if let type = field.type, type == "radio"{
                ShopCartUserDataCell.radioButtons.removeAll()
                if let view = Bundle.main.loadNibNamed("CheckoutForm", owner: self, options: nil)?[0] as? UIView{
                    let label = view.viewWithTag(1) as! UILabel
                    label.text = field.label
                    let container = view.viewWithTag(2) as! UIStackView
                if let options = field.select{
                    for item in options.values.sorted(){
                if let view = Bundle.main.loadNibNamed("PaymentMethodView", owner: self, options: nil)?[0] as? UIView{
                    let wrapper = RadioViewWrapper.init(view: view, field: field, option: item)
                    self.cache.append( wrapper)
                    container.addArrangedSubview(view)
                }
                    }
                    view.setNeedsLayout()
                    view.layoutIfNeeded()
                   
                }
                    
                    mBody.addArrangedSubview(view)
                   
                }
            }
        }
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    @objc func actionCheck(sender: UIButton){
        sender.isSelected = !sender.isSelected
        if  ShopCartUserDataCell.radioButtons.contains(sender){
            for item in ShopCartUserDataCell.radioButtons{
                if item != sender{
                    item.isSelected = false
                }
            }
        }
    }
    
    class CheckoutWrapper{
        
        var view : UIView
        var field : CheckoutField
        var option : String
        
        init(view : UIView, field: CheckoutField, option: String){
        self.view = view
        self.field = field
        self.option = option
            
            let label = view.viewWithTag(2) as! UILabel
            label.text = option
            let button = view.viewWithTag(1) as! UIButton
            button.setImage(UIImage.init(named: "checkbox"), for: .normal)
            button.setImage(UIImage.init(named: "tick"), for: .selected)
            button.addTarget(self, action: #selector(self.actionCheck(sender:)), for: .touchUpInside)
            
            if field.values.contains(option){
                button.isSelected = true
            }
        }
        
        @objc func actionCheck(sender: UIButton){
            sender.isSelected = !sender.isSelected
            
            
               
                if sender.isSelected {
                     field.values.insert(option)
                    
                } else {
                     field.values.remove(option)
                    
                }
                
            }
        }
    
    
    class RadioViewWrapper{
        var view : UIView
        var field : CheckoutField
        var option : String
        
        init(view : UIView, field: CheckoutField, option: String){
            self.view = view
            self.field = field
            self.option = option
            
            let label = view.viewWithTag(2) as! UILabel
                               label.text = option
                               let button = view.viewWithTag(1) as! UIButton
                               ShopCartUserDataCell.radioButtons.insert(button)
                                   button.setImage(UIImage.init(named: "checkbox"), for: .normal)
                                   button.setImage(UIImage.init(named: "tick"), for: .selected)
                                   button.addTarget(self, action: #selector(self.actionCheck(sender:)), for: .touchUpInside)
            
            if field.values.contains(option){
                button.isSelected = true
            }
        }
        
        @objc func actionCheck(sender: UIButton){
            sender.isSelected = !sender.isSelected
            if  sender.isSelected && ShopCartUserDataCell.radioButtons.contains(sender){
                
                for item in ShopCartUserDataCell.radioButtons{
                    if item != sender{
                        item.isSelected = false
                    }
                }
            }
            
           
               
                if sender.isSelected {
                    field.values.removeAll()
                    field.values.insert(option)
                    
                } else {
                    field.values.remove(option)
                    
                }
            
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = placeholders[textView]
            textView.textColor = colorPrimary
            holding[textView] = true
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if let b = holding[textView], b && !text.isEmpty {
            holding[textView] = false
            textView.textColor = colorPrimary
            textView.text = text
            
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let b = holding[textView], b {
            holding[textView] = false
            textView.text = nil
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            holding[textView] = true
            textView.text = placeholders[textView]
            textView.textColor = colorPrimary
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
       
            if let b = holding[textView], b {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        
    }
}
