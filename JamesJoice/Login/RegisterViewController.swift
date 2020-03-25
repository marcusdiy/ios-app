//
//  RegisterViewController.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit


 class RegisterViewController : UIViewController, KeyboardProtocol, UITextFieldDelegate, UIGestureRecognizerDelegate{
    public var scrollView: UIScrollView?
    
    public var activeField: UIView?
    
    
    private var registerView : RegisterView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.registerView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
       // self.automaticallyAdjustsScrollViewInsets = false
        
        self.scrollView = registerView?.mScrollView
        registerView?.mName.delegate = self
        registerView?.mSurname.delegate = self
        registerView?.mPhone.delegate = self
        registerView?.mEmail.delegate = self
        registerView?.mPassword.delegate = self
        registerView?.mRepeatPassword.delegate = self
        
     //   self.scrollView?.contentInsetAdjustmentBehavior = .never
        
        let vgr = UIGestureRecognizer.init(target: self, action: #selector(tappedAwayFromK))
        self.view.addGestureRecognizer(vgr)
        vgr.delegate = self
        
          let notificationCenter = NotificationCenter.default
             notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

             notificationCenter.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
             self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tappedAwayFromK)))
        
        
        
        
        let gr = UITapGestureRecognizer.init(target: self, action: #selector(self.access))
        gr.delegate = self
        self.registerView?.mAccessLabel.addGestureRecognizer(gr)
        
        self.registerView?.mForgotLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.forgot)))
    }
    
    public override func loadView() {
        super.loadView()
        if let view = Bundle.main.loadNibNamed("Register1", owner: self, options: nil)?[1] as? RegisterView{
            self.view = view
            self.registerView = view
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
            coordinator.animate(alongsideTransition: { (_) in

               // Code while it is transitioning

           }, completion: {_ in
              // Completion block
               self.registerView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
               self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                      self.registerView?.mScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //   self.loginView?.mScrollView.contentSize = CGSize.init(width: 667, height: 1300)
           }
           )
           
           
          
       }
    
       @objc func tappedAwayFromK(){
           self.activeField?.resignFirstResponder()
       }
       
       @objc func keyboardWillShow(n: Notification){
           self.keyboardDidShow(notification: n)
       }
       
       @objc func keyboardHidden(n: Notification){
           self.keyboardDidHide()
       }
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       self.activeField = textField
    }
    

    
    @objc func access(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func forgot(){
        performSegue(withIdentifier: "toForgot", sender: nil)
    }
 /*
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
  */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.registerView?.mPasswordToggle || touch.view == self.registerView?.mRepeatPasswordToggle{
            return false
        }else{
            return true
        }
    }
    
    
}
