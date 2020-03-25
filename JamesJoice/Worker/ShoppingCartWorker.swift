//
//  ShoppingCartWorker.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation
import Alamofire

class ShoppingCartWorker{
    
    func checkout(handler: @escaping (AFDataResponse<String>) -> Void, cart: NSDictionary){
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as? String else {return}
         let address = URL.init(string: url)?.appendingPathComponent("v1")
             .appendingPathComponent("checkout")
         
     
         if let address = address, let keys = cart.allKeys as? [Int64]{
            var components = URLComponents.init(string: address.absoluteString)
            for item in cart{
                guard let key = item.key as? Int64,
                    let value = item.value as? Int,
                    let index = keys.firstIndex(of: key) else { continue }
                components?.queryItems?.append(URLQueryItem.init(name: "cart[\(index)][id]", value: String.init(key)))
                components?.queryItems?.append(URLQueryItem.init(name: "cart[\(index)][qty]", value: String.init(value)))
          
            }
        // let h = HTTPHeaders.init(headers)
            let req = AF.request(components!.string!, method: .get)
            
             req.responseString(completionHandler: handler)
         }
    }
    
    func submitOrder(
        cart: NSDictionary,
               shippingMethod : ShippingMethod,
               paymentMethod : PaymentMethod,
               params : [CheckoutField],
               id : Int64,
        handler: @escaping (AFDataResponse<Any>) -> Void
       
    ){
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseUrl") as? String else {return}
                let address = URL.init(string: url)?.appendingPathComponent("v1")
                    .appendingPathComponent("checkout")
                
            
                if let address = address, let keys = cart.allKeys as? [Int64]{
                    var parameters = [String: String]()
                   for item in cart{
                       guard let key = item.key as? Int64,
                           let value = item.value as? Int,
                           let index = keys.firstIndex(of: key) else { continue }
                       parameters[ "cart[\(index)][id]"] = String.init(key)
                       parameters[ "cart[\(index)][qty]"] = String.init(value)
                 
                   }
                    parameters[ "shipping[id]"] =  shippingMethod.id ?? ""
                    parameters[ "payment[id]"] =  paymentMethod.id ?? ""
                    parameters[ "order[user_id]"] =  String.init(id)
                    
                    for item in params{
                        
                        for option in item.values{
                            guard let name = item.name else { continue }
                            parameters[ "\(name)"] =  option
                        }
                    }
                    /*
                    parameters[ "order[first_name]"] =  firstName
                    parameters[ "order[last_name]"] =  lastName
                    parameters[ "order[email]"] =  email
                    parameters[ "order[notes]"] =  notes
 */
                    
                    let headers = [
                        "Content-Type": "application/x-www-form-urlencoded"
                    ]
                
                          let h = HTTPHeaders.init(headers)
                          let req = AF.request(address, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: h)
                              req.responseJSON(completionHandler: handler)
                          
                }
    }
}

/*
 
 params.put("shipping_method", shippingMethod.getId());
 params.put("payment_method", paymentMethod.getId());

 params.put("order[usersId]", String.valueOf(id));
 params.put("order[first_name]", firstName);
 params.put("order[last_name]", lastName);
 params.put("order[email]", email);
 params.put("order[notes]", notes);
 */
