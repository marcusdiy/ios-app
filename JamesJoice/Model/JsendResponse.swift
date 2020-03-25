//
//  JsendResponse.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 09/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class JSendResponse<T> : JsonSerilizable where T : JsonSerilizable {
    
    var status : String?
    var data : T?
    var code : Int?
    
    required public init?(dictionary: NSDictionary) {
        status = dictionary["status"] as? String
        code = dictionary["code"] as? Int
        if let data = dictionary["data"] as? NSDictionary{
            self.data = T.init(dictionary: data)
        }
    }
    
}

class JSendArrayResponse<T> : JsonSerilizable where T : JsonSerilizable{
    
    var status : String?
    var data : Array<T>?
    var code : Int?
    
    required public init?(dictionary: NSDictionary) {
        status = dictionary["status"] as? String
        code = dictionary["code"] as? Int
        if let data = dictionary["data"] as? NSArray{
            self.data = T.modelsFromDictionaryArray(array: data)
        }
    }
}
