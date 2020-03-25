//
//  LoginWorker.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 09/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginWorker{
    
   public func login(username: String, password: String, handler: @escaping (AFDataResponse<Any>) -> Void){
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "email": username,
            "pass": password,
            "device": UIDevice.current.name
        ]
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as? String else {return}
        let address = URL.init(string: url)?.appendingPathComponent("v1")
            .appendingPathComponent("users")
        .appendingPathComponent("auth")
        
        if let address = address{
        let h = HTTPHeaders.init(headers)
        let req = AF.request(address, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: h)
            req.responseJSON(completionHandler: handler)
        }
         
    }
    
}
