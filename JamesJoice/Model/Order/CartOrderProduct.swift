//
//  CartOrderProduct.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class CartOrderProduct : JsonSerilizable{
    
    var id, name, qty, total, subtotal : String?
    var subtotalTax, totalTax: String?
    var metadata : [ProductMetaData]?
    
    required init?(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.qty = dictionary["qty"] as? String
        self.total = dictionary["total"] as? String
        self.subtotal = dictionary["subtotal"] as? String
        self.subtotalTax = dictionary["subtotal_tax"] as? String
        self.totalTax = dictionary["total_tax"] as? String
        
        if let array = dictionary["meta_data"]  as? NSArray{
            metadata = ProductMetaData.modelsFromDictionaryArray(array: array)
        }
    }
    
    
    
    
}

class ProductMetaData : JsonSerilizable{
    
    
    
    var key, value, name : String?
    
    
    required init?(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
         self.value = dictionary["value"] as? String
         self.key = dictionary["key"] as? String
    }
}
