//
//  RegisterView.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

public class RegisterView : UIView, UIScrollViewDelegate{
    
    
    @IBOutlet weak var mEmailIcon: UIImageView!
    @IBOutlet weak var mSurnameIcon: UIImageView!
    @IBOutlet weak var mPhoneIcon: UIImageView!
    @IBOutlet weak var mNameIcon: UIImageView!
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mAccessLabel: UILabel!
    @IBOutlet weak var mForgotLabel: UILabel!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mSurname: TextField!
    @IBOutlet weak var mPhone: TextField!
    @IBOutlet weak var mName: TextField!
    @IBOutlet weak var mEmail: TextField!
    @IBOutlet weak var mPassword: TextField!
    @IBOutlet weak var mRepeatPassword: TextField!
    
    @IBOutlet weak var mRepeatPasswordToggle: UIButton!
    @IBOutlet weak var mPasswordToggle: UIButton!
    @IBOutlet weak var mRegisterButton: UIButton!
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        mNameIcon.image = mNameIcon.image?.withRenderingMode(.alwaysTemplate)
               mNameIcon.tintColor = jOrange
        
        mSurnameIcon.image = mSurnameIcon.image?.withRenderingMode(.alwaysTemplate)
               mSurnameIcon.tintColor = jOrange
        
        mEmailIcon.image = mEmailIcon.image?.withRenderingMode(.alwaysTemplate)
               mEmailIcon.tintColor = jOrange
        
        mPhoneIcon.image = mPhoneIcon.image?.withRenderingMode(.alwaysTemplate)
               mPhoneIcon.tintColor = jOrange
      
        mName.defaultTextAttributes.updateValue(letterSpacing,
        forKey: NSAttributedString.Key.kern)
        
        mSurname.defaultTextAttributes.updateValue(letterSpacing,
        forKey: NSAttributedString.Key.kern)
        
        mPhone.defaultTextAttributes.updateValue(letterSpacing,
        forKey: NSAttributedString.Key.kern)
        
        mEmail.defaultTextAttributes.updateValue(letterSpacing,
        forKey: NSAttributedString.Key.kern)
        
        mPassword.defaultTextAttributes.updateValue(letterSpacing,
        forKey: NSAttributedString.Key.kern)
        
        mRepeatPassword.defaultTextAttributes.updateValue(letterSpacing,
        forKey: NSAttributedString.Key.kern)
        
        mEmail.clipsToBounds = true;
        mEmail.layer.cornerRadius = corners;
        mPassword.clipsToBounds = true;
        mPassword.layer.cornerRadius = corners;
        
        mName.clipsToBounds = true;
        mName.layer.cornerRadius = corners;
        mSurname.clipsToBounds = true;
        mSurname.layer.cornerRadius = corners;
        
        mPhone.clipsToBounds = true;
        mPhone.layer.cornerRadius = corners;
        mRepeatPassword.clipsToBounds = true;
        mRepeatPassword.layer.cornerRadius = corners;
        
        mRegisterButton.clipsToBounds = true;
        mRegisterButton.layer.cornerRadius = corners;
        
        if let attributedTitle = mRegisterButton.attributedTitle(for: .normal) {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
            mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
            mutableAttributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedTitle.length))
            mRegisterButton.setAttributedTitle(mutableAttributedTitle, for: .normal)
        }
        
        mScrollView.delegate = self
        
        mEmail.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        mPassword.attributedPlaceholder =
        NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        mName.attributedPlaceholder =
        NSAttributedString(string: "Nome", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        mSurname.attributedPlaceholder =
        NSAttributedString(string: "Cognome", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        mPhone.attributedPlaceholder =
        NSAttributedString(string: "Telefono", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        mRepeatPassword.attributedPlaceholder =
        NSAttributedString(string: "Ripeti Password", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        if let attributedTitle = mTitleLabel.attributedText {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
            mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
           mTitleLabel.attributedText = mutableAttributedTitle
        }
        
      //  self.mPasswordToggle.addTarget(self, action: #selector(self.actionTogglePassword(_:)), for: .touchUpInside)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @IBAction func actionTogglePassword(_ sender: Any) {
        self.mPassword.isSecureTextEntry = !mPassword.isSecureTextEntry
    }
    @IBAction func actionToggleRepeatPassword(_ sender: Any) {
        self.mRepeatPassword.isSecureTextEntry = !mRepeatPassword.isSecureTextEntry
    }
}
