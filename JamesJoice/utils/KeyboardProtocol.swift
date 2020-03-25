//
//  KeyboardProtocol.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 06/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

public protocol KeyboardProtocol{
    
    var scrollView: UIScrollView? { get set }
    var activeField : UIView? { get set }
    var view : UIView! {get set}
    
    func keyboardDidShow(notification: Notification)
    
    func keyboardDidHide()
    
}

extension KeyboardProtocol{
    
    func keyboardDidShow(notification: Notification){
        let info = notification.userInfo
        guard let activeField = self.activeField else { return }
        guard let rect = info?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let kbSize = rect.size
           
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0);
           scrollView?.contentInset = contentInsets;
           scrollView?.scrollIndicatorInsets = contentInsets;
        
           // If active text field is hidden by keyboard, scroll it so it's visible
           // Your app might not need or want this behavior.
        var aRect = self.view.frame;
           aRect.size.height -= kbSize.height;
     //   if !aRect.contains(activeField.frame.origin)  {
        if !aRect.contains(CGPoint.init(x: 0, y: activeField.frame.origin.y + activeField.frame.height)  )  {
            self.scrollView?.scrollRectToVisible(activeField.frame, animated: true)
           // scrollView?.setContentOffset(CGPoint(x: 0, y: activeField.frame.origin.y), animated: true)
               
           }
    }
    
    func keyboardDidHide(){
        let contentInsets = CGPoint.zero//UIEdgeInsets.zero
        scrollView?.contentOffset = contentInsets
       // scrollView?.contentInset = contentInsets;
        scrollView?.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
