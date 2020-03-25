//
//  ShippingMethod.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class ShippingMethod : JsonSerilizable, Hashable{
    
    
    
    var id, name, descrizione : String?
    var price : Int?
    var fields : Array<CheckoutField>?
    var paymentMethods : Array<String>?
    var conditions : Array<Array<String>>?
    var selected : Bool = false
    
    required init?(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.descrizione = dictionary["descrizione"] as? String
        if let array = dictionary["fields"] as? NSArray{
            self.fields = CheckoutField.modelsFromDictionaryArray(array: array)
        }
        self.paymentMethods = dictionary["payment_methods"] as? Array<String>
        self.conditions = dictionary["conditions"] as? Array<Array<String>>
    }
    
    static func == (lhs: ShippingMethod, rhs: ShippingMethod) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
}
