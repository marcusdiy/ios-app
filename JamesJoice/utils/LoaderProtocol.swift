//
//  LoaderProtocol.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 12/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit

public protocol LoaderProtocol : class{
    
    var mProgressView: UIProgressView? {get set}
    var mLoaderView : UIView? {get set}
}

extension LoaderProtocol{
    
    func addLoader(_ controller: UIViewController){
        guard let loaderView = Bundle.main.loadNibNamed("LoaderView", owner: controller, options: nil)?[0] as? UIView else{
            return
        }
        controller.view.addSubview(loaderView)
        loaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loaderView.frame = controller.view.bounds
        mProgressView = loaderView.viewWithTag(1) as? UIProgressView
        mLoaderView = loaderView
        hideLoader()
       
        
    }
    
    func showLoader(){
        mLoaderView?.isHidden = false
    }
    
    func hideLoader(){
        mLoaderView?.isHidden = true
    }
    
}
