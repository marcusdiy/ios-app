//
//  OrderShipping.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class OrderShipping : JsonSerilizable{
    
    var method, latitude, longitude, accuracy, address, civic, city : String?
    
    required init?(dictionary: NSDictionary) {
        self.method = dictionary["method"] as? String
        self.latitude = dictionary["latitude"] as? String
        self.longitude = dictionary["longitude"] as? String
        self.accuracy = dictionary["accuracy"] as? String
        self.address = dictionary["address"] as? String
        self.civic = dictionary["civic"] as? String
        self.city = dictionary["city"] as? String
    }
    
    
    
    
}
