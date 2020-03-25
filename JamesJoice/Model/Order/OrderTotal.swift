//
//  OrderTotal.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class OrderTotal : JsonSerilizable{
    
    var total, discount, fullTotal, feesTotal : String?
    
    required init?(dictionary: NSDictionary) {
        self.total = dictionary["total"] as? String
        self.discount = dictionary["discount"] as? String
        self.fullTotal = dictionary["full_total"] as? String
        self.feesTotal = dictionary["fees_total"] as? String
    }
    
    
    
    
}
