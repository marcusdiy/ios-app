//
//  PaymentMethod.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class PaymentMethod : JsonSerilizable, Hashable{
   
    
    
    var id, description, name : String?
    var settings : [String : String]?
    var selected : Bool = false
    
    required init?(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
         self.description = dictionary["description"] as? String
         self.name = dictionary["name"] as? String
        if let dict = dictionary["settings"] as? NSDictionary{
                   settings = [String : String]()
                   for item in dict.allKeys{
                       if let key = item as? String{
                           settings?[key] = dict[key] as? String
                       }
                   }
               }
    }
    
    
    static func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
        lhs.id == rhs.id
       }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
