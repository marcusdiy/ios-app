//
//  OrderPayment.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class OrderPayment : JsonSerilizable{
    
    var id, name, price : String?
    
    required init?(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
         self.name = dictionary["name"] as? String
         self.price = dictionary["price"] as? String
    }
    
    
}
