//
//  ForgotView.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

class ForgotView : UIView{
    
    
    @IBOutlet weak var mEmailIcon: UIImageView!
    @IBOutlet weak var mTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mParagraph: UILabel!
    @IBOutlet weak var mEmail: UIButton!
    @IBOutlet weak var mTextField: TextField!
    @IBOutlet weak var mAccessLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mTextField.defaultTextAttributes.updateValue(letterSpacing,
        forKey: NSAttributedString.Key.kern)
        
        mTextField.clipsToBounds = true;
        mTextField.layer.cornerRadius = corners;
        
        mEmail.clipsToBounds = true;
        mEmail.layer.cornerRadius = corners;
        
        mTextField.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: jOrange,
        NSAttributedString.Key.kern: letterSpacing])
        
        mEmailIcon.image = mEmailIcon.image?.withRenderingMode(.alwaysTemplate)
               mEmailIcon.tintColor = jOrange
        
    }
}
