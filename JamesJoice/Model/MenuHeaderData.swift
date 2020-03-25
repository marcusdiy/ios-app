//
//  MenuHeaderData.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 11/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class MenuHeaderData : JsonSerilizable{
    
    var header : Array<Data>?
    
    required init?(dictionary: NSDictionary) {
        if let array = dictionary["menu_header"] as? NSArray{
            self.header = Data.modelsFromDictionaryArray(array: array)
        }
    }
    
    
    class Data : JsonSerilizable{
        var action, url, src : String?
        
        required init?(dictionary: NSDictionary) {
            self.action = dictionary["action"] as? String
             self.url = dictionary["url"] as? String
             self.src = dictionary["src"] as? String
        }
        
        
    }
    
}
