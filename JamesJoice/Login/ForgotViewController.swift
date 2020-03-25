//
//  ForgotViewController.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

class ForgotViewController : UIViewController, KeyboardProtocol, UIGestureRecognizerDelegate{
    
    var scrollView: UIScrollView?
    
    var activeField: UIView?
    
    
    private var forgotView : ForgotView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = forgotView?.mScrollView
        self.activeField = forgotView?.mTextField
        
          let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tappedAwayFromK)))
        let gr = UITapGestureRecognizer.init(target: self, action: #selector(self.access))
        self.forgotView?.mAccessLink.addGestureRecognizer(gr)
        gr.delegate = self
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.forgotView?.mScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.forgotView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
        self.forgotView?.mTopConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
        self.forgotView?.mBottomConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
        self.forgotView?.setNeedsUpdateConstraints()
        self.forgotView?.updateConstraints()
 
        
    //    notificationCenter.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        if let view = Bundle.main.loadNibNamed("Forgot", owner: self, options: nil)?[0] as? ForgotView{
            self.view = view
            forgotView = view
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     /*   self.forgotView?.mScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               self.forgotView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
               self.forgotView?.mTopConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
               self.forgotView?.mBottomConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
               self.forgotView?.setNeedsUpdateConstraints()
               self.forgotView?.updateConstraints()
 */
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
         coordinator.animate(alongsideTransition: { (_) in

            // Code while it is transitioning

        }, completion: {_ in
           // Completion block
            self.forgotView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                   self.forgotView?.mScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         //   self.loginView?.mScrollView.contentSize = CGSize.init(width: 667, height: 1300)
            self.forgotView?.mTopConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
            self.forgotView?.mBottomConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
            self.forgotView?.setNeedsUpdateConstraints()
            self.forgotView?.updateConstraints()
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
    
 /*   @objc func orientationChanged(){
        self.forgotView?.mScrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
                      self.forgotView?.mTopConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
                      self.forgotView?.mBottomConstraint.constant = UIDevice.current.orientation.isLandscape ? 16 : 97
                      self.forgotView?.setNeedsUpdateConstraints()
                      self.forgotView?.updateConstraints()
    }*/
    
    @objc func access(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
