//
//  ProductWorker.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 11/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import Alamofire

class ProductWorker{
    
    public func products( handler: @escaping (AFDataResponse<Any>) -> Void){
          
           guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as? String else {return}
           let address = URL.init(string: url)?.appendingPathComponent("v1")
               .appendingPathComponent("products")
           
           
           if let address = address{
          // let h = HTTPHeaders.init(headers)
           let req = AF.request(address, method: .get)
               req.responseJSON(completionHandler: handler)
           }
            
       }
    
    public func categories( handler: @escaping (AFDataResponse<Any>) -> Void){
       
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as? String else {return}
        let address = URL.init(string: url)?.appendingPathComponent("v1")
            .appendingPathComponent("categories")
        
        
        if let address = address{
       // let h = HTTPHeaders.init(headers)
        let req = AF.request(address, method: .get)
            req.responseJSON(completionHandler: handler)
        }
         
    }
    
    public func header( handler: @escaping (AFDataResponse<Any>) -> Void){
       
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as? String else {return}
        let address = URL.init(string: url)?.appendingPathComponent("v1")
            .appendingPathComponent("variables")
        
        
        if let address = address{
       // let h = HTTPHeaders.init(headers)
        let req = AF.request(address, method: .get)
            req.responseJSON(completionHandler: handler)
        }
         
    }
}
