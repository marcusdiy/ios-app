//
//  ShippingMethodCell.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 17/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

class ShippingMethodCell : UITableViewCell, UITextViewDelegate, CLLocationManagerDelegate{
    
   
    @IBOutlet weak var mCard: UIView!
    @IBOutlet weak var mCheck: UIButton!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mBody: UIStackView!
    
    var action : (() -> Void)?
    var holding = [UITextView: Bool]()
    var placeholders = [UITextView : String]()
    var gpsButton : UIView?
    
    var item : ShippingMethod?{
        didSet{
            populate()
        }
    }
    
    var fields : NSMutableSet?
    let notificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    
    static var checks = Set<UIButton>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mCard.clipsToBounds = true
        mCard.layer.cornerRadius = corners
        ShippingMethodCell.checks.insert(mCheck)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    private func populate(){
        guard let item = self.item else { return }
        
        if let name = item.name{
            mTitle.attributedText = NSAttributedString.init(string: name)
            Utils.setup(label: mTitle)
        }
        mCheck.setImage(UIImage.init(named: "checkbox"), for: .normal)
        mCheck.setImage(UIImage.init(named: "tick"), for: .selected)
        mCheck.addTarget(self, action: #selector(self.actionCheck(sender:)), for: .touchUpInside)
        
        mCheck.isSelected = item.selected
       
        
        guard let fields = item.fields else { return }
        for view in mBody.arrangedSubviews{
            view.removeFromSuperview()
        }
        
        if !item.selected{
            return
        }
        for field in fields{
            if let type = field.type, type == "text", let label = field.label{
                           if let view = Bundle.main.loadNibNamed("FormTextField", owner: self, options: nil)?[0] as? UIView{
                               let textField = view.viewWithTag(1) as! UITextField
                               
                                      
                               let place  = Utils.setup(attributedString: NSAttributedString.init(string: label))
                               place.addAttribute(NSAttributedString.Key.foregroundColor, value: colorPrimary, range: NSMakeRange(0, place.length))
                               textField.attributedPlaceholder = place
                               if let value = field.value, let stored = prefs?.string(forKey: value){
                                   let text = Utils.setup(attributedString: NSAttributedString.init(string: stored))
                                   text.addAttribute(NSAttributedString.Key.foregroundColor, value: colorPrimary, range: NSMakeRange(0, place.length))
                                   textField.attributedText = text
                               }
                               mBody.addArrangedSubview(view)
                              
                               
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
                           }
            }else if let type = field.type, type == "gps_current_location"{
                if  let view = Bundle.main.loadNibNamed("GPSButtonView", owner: self, options: nil)?[0] as? UIView{
                    let label = view.viewWithTag(1) as! UILabel
                    Utils.setup(label: label)
                    self.gpsButton = view
                    
                    view.clipsToBounds = true
                    view.layer.cornerRadius = corners
                    
                    view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.actionGps(sender:))))
                    
                    mBody.addArrangedSubview(view)
                    
                    if let fields = self.fields, fields.contains(field){
                        locationManager.startUpdatingLocation()
                    }
                }
            }
        }
    }
    
    @objc func actionGps(sender: UITapGestureRecognizer){
        let view = sender.view
         let label = view?.viewWithTag(1) as! UILabel
        label.attributedText = NSAttributedString.init(string: "Acquisizione in corso...")
        Utils.setup(label: label)
        view?.alpha = 0.5
        
     /*   notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
        }
        */
        locationManager.startUpdatingLocation()
    }
    
    @objc func actionCheck(sender: UIButton){
        
        mCheck.isSelected = !mCheck.isSelected
        self.item?.selected = mCheck.isSelected
        let checks = ShippingMethodCell.checks
        if mCheck.isSelected{
            for item in checks{
                if item != sender{
                    item.isSelected = false
                    
                }
            }
            
          
        }
      
        action?()
    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     // 1
     guard let location = locations.first else {
       return
     }
    if let field = self.item?.fields?.filter({ item in
        guard let type = item.type else { return false }
        return type == "gps_current_location"
    }).first{
        field.values.removeAll()
        field.values.insert("\(location.coordinate.latitude), \(location.coordinate.latitude)")
        self.fields = self.fields?.add(field) as? NSMutableSet
    }
    locationManager.stopUpdatingLocation()
       // create CLLocation from the coordinates of CLVisit
      // let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)

        if let label = gpsButton?.viewWithTag(1) as? UILabel, let title = gpsButton?.viewWithTag(2) as? UILabel{
            label.attributedText = NSAttributedString.init(string: "\(location.coordinate.latitude), \(location.coordinate.latitude)")
           
               Utils.setup(label: label)
            title.attributedText =  NSAttributedString.init(string: "Posizione GPS aquisita")
            Utils.setup(label: title)
        }
        gpsButton?.alpha = 1.0
        gpsButton?.backgroundColor = colorPrimary
       // Get location description
     }
    
    @IBAction func actionCheckState(_ sender: UIButton) {
        self.item?.selected = sender.isSelected
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
               textView.textColor = colorPrimary
               textView.text = text
               holding[textView] = false
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
       
       func textViewDidChangeSelection(_ textView: UITextView) {
          
               if let b = holding[textView], b {
                   textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
               }
           
       }
}
