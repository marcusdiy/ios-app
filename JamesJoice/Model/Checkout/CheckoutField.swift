//
//  CheckoutField.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 16/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class CheckoutField : JsonSerilizable, Hashable, Equatable, NSCopying{
    
    
    
    
    
    var name, type, label, value : String?
    var select : [String : String]?
    var values = Set<String>()//[String: Set<String>]()
    
    required init?(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        self.type = dictionary["type"] as? String
        self.label = dictionary["label"] as? String
        self.value = dictionary["value"] as? String
        
        if let dict = dictionary["options"] as? NSDictionary{
            select = [String : String]()
            for item in dict.allKeys{
                if let key = item as? String{
                    select?[key] = dict[key] as? String
                }
            }
        }
    }
    
     required init(_ with: CheckoutField) {
        self.name = with.name
        self.type = with.type
        self.label = with.label
        self.value = with.value
        self.select = with.select
        for item in with.values{
            self.values.insert(item)
        }
    }
    
    
    static func == (lhs: CheckoutField, rhs: CheckoutField) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
         return CheckoutField.init(self)
    }
}
