//
//  LoginView.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

public let letterSpacing = 1.4
let corners = CGFloat(10.0)
let jOrange = UIColor.init(named: "jOrange")

public class LoginView : UIView{
    
    
    @IBOutlet weak var mForgot: UILabel!
    @IBOutlet weak var mLoginButton: UIButton!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mFacebookButton: UIButton!
    
    @IBOutlet weak var mEmailButton: UIButton!
    @IBOutlet weak var mGoogleButton: UIButton!
    @IBOutlet weak var mEmail: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    @IBOutlet weak var mPasswordToggle: UIButton!
    @IBOutlet weak var mEmailIcon: UIImageView!
    
    
    @IBOutlet weak var mMailBtnIcon: UIImageView!
    @IBOutlet weak var mOppureLabel: UILabel!
    @IBAction func actioTogglePassword(_ sender: Any) {
        mPassword.isSecureTextEntry = !mPassword.isSecureTextEntry
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        mEmailIcon.image = mEmailIcon.image?.withRenderingMode(.alwaysTemplate)
        mEmailIcon.tintColor = jOrange
        
//        mMailBtnIcon.image = mMailBtnIcon.image?.withRenderingMode(.alwaysTemplate)
 //       mMailBtnIcon.tintColor = UIColor.white
        
        mPassword.defaultTextAttributes.updateValue(letterSpacing,
                   forKey: NSAttributedString.Key.kern)
        mEmail.defaultTextAttributes.updateValue(letterSpacing,
            forKey: NSAttributedString.Key.kern)
        
        if let attributedTitle = mLoginButton.attributedTitle(for: .normal) {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
            mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
            mutableAttributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedTitle.length))
            mLoginButton.setAttributedTitle(mutableAttributedTitle, for: .normal)
        }
        
        if let attributedTitle = mOppureLabel.attributedText {
                   let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
                   mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
                  mOppureLabel.attributedText = mutableAttributedTitle
               }
        
        setupButtonTitle(button: mFacebookButton)
        setupButtonTitle(button: mGoogleButton)
        setupButtonTitle(button: mEmailButton)
        
        mEmail.clipsToBounds = true;
        mEmail.layer.cornerRadius = corners;
        mPassword.clipsToBounds = true;
        mPassword.layer.cornerRadius = corners;
        
        mLoginButton.clipsToBounds = true;
        mLoginButton.layer.cornerRadius = corners;
        
        mFacebookButton.clipsToBounds = true;
        mFacebookButton.layer.cornerRadius = corners;
        
        mGoogleButton.clipsToBounds = true;
        mGoogleButton.layer.cornerRadius = corners;
        
        mEmailButton.clipsToBounds = true;
        mEmailButton.layer.cornerRadius = corners;
        
        mEmail.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        mPassword.attributedPlaceholder =
        NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
    /*    self.mEmailIcon.image?.withRenderingMode(.alwaysTemplate)
        self.mEmailIcon.image?.withTintColor(UIColor.red)
        self.mPasswordToggle.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.mPasswordToggle.tintColor = UIColor.red
 */
    }
    
    private func setupButtonTitle(button : UIButton){
    if let attributedTitle = button.attributedTitle(for: .normal) {
               let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
               mutableAttributedTitle.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSMakeRange(0, attributedTitle.length))
              
               button.setAttributedTitle(mutableAttributedTitle, for: .normal)
           }
    }
    
}
