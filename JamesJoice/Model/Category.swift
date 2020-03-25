//
//  Category.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 11/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class Category : JsonSerilizable, Hashable, Comparable{
    
    
    
    var id : Int64?
    var name : String?
    var permalink, content : String?
    var order: Int = -1
    
    required init?(dictionary: NSDictionary) {
        if let idString = dictionary["id"] as? String{
            self.id = Int64.init(idString)
        }
        self.name = dictionary["name"] as? String
        self.permalink = dictionary["permalink"] as? String
        self.content = dictionary["content"] as? String
        
    }
    
    static func < (lhs: Category, rhs: Category) -> Bool {
        return lhs.order < rhs.order
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
