//
//  ServerImage.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 11/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class ServerImage : JsonSerilizable{
    
    var thumb, full, medium : Image?
    
    required init?(dictionary: NSDictionary) {
        if let array = dictionary["thumb"] as? NSArray{
            self.thumb = Image.init(array: array)
        }
        if let array = dictionary["full"] as? NSArray{
            self.full = Image.init(array: array)
        }
        if let array = dictionary["medium"] as? NSArray{
            self.medium = Image.init(array: array)
        }
    }
    
    
     class Image {
        
        var url: String?
        var height, width : Int?
        
        required init?(array: NSArray) {
            guard array.count > 3 else { return }
            self.url = array[0] as? String
            self.height = array[2] as? Int
            self.width = array[1] as? Int
        }
        
        
    }
}
