//
//  LoginViewController.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


 class LoginViewController : UIViewController, KeyboardProtocol, UIGestureRecognizerDelegate, UITextFieldDelegate{
    public var scrollView: UIScrollView?
    
    public var activeField: UIView?
    
    
    private var loginView : LoginView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        loginView?.mForgot.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(actionForgot)))
        loginView?.mEmailButton.addTarget(self, action: #selector(actionRegister), for: .touchUpInside)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let notificationCenter = NotificationCenter.default
                    notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

                    notificationCenter.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
                    self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tappedAwayFromK)))
               
        let gr = UIGestureRecognizer.init(target: self, action: #selector(tappedAwayFromK))
        self.view.addGestureRecognizer(gr)
        gr.delegate = self
        
        self.loginView?.mPassword.delegate = self
        self.loginView?.mEmail.delegate = self
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.loginView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
        
        self.loginView?.mLoginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    public override func loadView() {
        super.loadView()
        
        if let view = Bundle.main.loadNibNamed("Login", owner: self, options: nil)?[2] as? LoginView{
            self.view = view
            self.loginView = view
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let scrollView = self.loginView?.mScrollView else { return }
 /*       let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
 */
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
         coordinator.animate(alongsideTransition: { (_) in

            // Code while it is transitioning

        }, completion: {_ in
           // Completion block
            self.loginView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                   self.loginView?.mScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         //   self.loginView?.mScrollView.contentSize = CGSize.init(width: 667, height: 1300)
        }
        )
        
        
       
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    @objc func actionForgot(){
        performSegue(withIdentifier: "toForgot", sender: nil)
    }
    
    @objc func actionRegister(){
        performSegue(withIdentifier: "toRegistration", sender: nil)
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
    
    @objc func login(){
        guard let username = self.loginView?.mEmail.text, let password = self.loginView?.mPassword.text else {
            return
        }
        LoginWorker().login(username: username, password: password, handler: {response in
            switch response.result {
            case let .success(value):
               // Do something useful with `result`, the decoded result of
               // type `ExpectedResponse` that you received from the server.
               
                if let json =  value as? [String: Any] {
                print("JSON: \(json)") // serialized json response
                    let dict = NSDictionary.init(dictionary: json)
                        let model = JSendResponse<User>.init(dictionary: dict)
                    print("Coversion success.")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toMain", sender: nil)
                    }
                }
            
                break
            case let .failure(error):
               // Handle the error, a 404 for example.
                print(error)
                break
            }
            
        })//.login(username: username, password: password){ response in
            
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.loginView?.mPasswordToggle ||
            [loginView?.mEmailButton, loginView?.mLoginButton].contains(where: {item in
            item == touch.view
            
        }){
            return false
        }else{
            return true
        }
    }
}
