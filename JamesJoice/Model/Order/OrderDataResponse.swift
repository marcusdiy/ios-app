//
//  OrderDataResponse.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class OrderDataResponse : JsonSerilizable{
    
    var progress : Int?
    var cart : Array<CartOrderProduct>?
    var fees : Array<OrderFee>?
    var totals : OrderTotal?
    var billing : OrderBilling?
    var payment : OrderPayment?
    var shipping : OrderShipping?
    
    required init?(dictionary: NSDictionary) {
        if let value = dictionary["progress"] as? String{
            self.progress = Int.init(value)
        }
        if let array = dictionary["cart"] as? NSArray{
            self.cart = CartOrderProduct.modelsFromDictionaryArray(array: array)
        }
        if let array = dictionary["fees"] as? NSArray{
            self.fees = OrderFee.modelsFromDictionaryArray(array: array)
        }
        if let dict = dictionary["totals"] as? NSDictionary{
            self.totals = OrderTotal.init(dictionary: dict)
        }
        if let dict = dictionary["billing"] as? NSDictionary{
                   self.billing = OrderBilling.init(dictionary: dict)
               }
        if let dict = dictionary["payment"] as? NSDictionary{
                   self.payment = OrderPayment.init(dictionary: dict)
               }
        if let dict = dictionary["shipping"] as? NSDictionary{
                   self.shipping = OrderShipping.init(dictionary: dict)
               }
    }
    
    
    
    
    
}
