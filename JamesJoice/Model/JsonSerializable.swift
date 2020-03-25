//
//  JsonSerializable.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 09/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

protocol JsonSerilizable{
    
     init?(dictionary: NSDictionary)
    
    
}

extension JsonSerilizable{
    
    public static func modelsFromDictionaryArray(array:NSArray) -> [Self]
    {
        var models:[Self] = []
        for item in array
        {
            models.append(Self(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
}
