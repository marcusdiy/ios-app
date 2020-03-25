//
//  OrderFee.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class OrderFee : JsonSerilizable{
    
    
    
    var name, total : String?
    
    required init?(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        self.total = dictionary["total"] as? String
    }
    
}
