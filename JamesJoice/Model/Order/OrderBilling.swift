//
//  OrderBilling.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class OrderBilling : JsonSerilizable{
    
    var firstName : String?

    var  lastName : String?
    var  company : String?
    
    var address1 : String?
    
    var  address2 : String?
    var  city, state, postcode, country, phone : String?
    
    
    required init?(dictionary: NSDictionary) {
        self.firstName = dictionary["first_name"] as? String
         self.lastName = dictionary["last_name"] as? String
         self.company = dictionary["company"] as? String
         self.address1 = dictionary["address_1"] as? String
         self.address2 = dictionary["address_2"] as? String
         self.city = dictionary["city"] as? String
         self.state = dictionary["state"] as? String
         self.postcode = dictionary["postcode"] as? String
         self.country = dictionary["country"] as? String
         self.phone = dictionary["phone"] as? String
    }
    
    
}
