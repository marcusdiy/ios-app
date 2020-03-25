//
//  CheckoutData.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class CheckoutData : JsonSerilizable{
    
    var fields : Array<CheckoutField>?
    var paymentMethods : Array<PaymentMethod>?
    var shippingMethod : Array<ShippingMethod>?
    
    required init?(dictionary: NSDictionary) {
        if let array = dictionary["checkout_fields"] as? NSArray{
            if let array = array.firstObject as? NSArray{
                fields = CheckoutField.modelsFromDictionaryArray(array: array)
            }
        }
        
        if let array = dictionary["shipping_methods"] as? NSArray{
            shippingMethod = ShippingMethod.modelsFromDictionaryArray(array: array)
        }
        
        if let array = dictionary["payment_methods"] as? NSArray{
            paymentMethods = PaymentMethod.modelsFromDictionaryArray(array: array)
        }
    }
    
    
}
