//
//  Product.swift
//  JamesJoice
//
//  Created by Marco Di Nicola on 11/03/2020.
//  Copyright © 2020 Marco Di Nicola. All rights reserved.
//

import Foundation

class Product : JsonSerilizable, Hashable, Comparable{
    
    
    
    var id : Int64?
    var name : String?
    var permalink, content, regular_price, sale_price : String?
    var visibility, qty, importdata, stock : String?
    var image : Array<ServerImage>?
    var categories : Array<Int64>?
    var category : Category?
    
    required init?(dictionary: NSDictionary) {
        
        if let idString = dictionary["id"] as? String{
            self.id = Int64.init(idString)
        }
        self.name = dictionary["name"] as? String
        self.permalink = dictionary["permalink"] as? String
        self.regular_price = dictionary["regular_price"] as? String
        self.content = dictionary["content"] as? String
        self.sale_price = dictionary["sale_price"] as? String
        self.visibility = dictionary["visibility"] as? String
        self.qty = dictionary["qty"] as? String
        self.stock = dictionary["stock"] as? String
        self.importdata = dictionary["importdata"] as? String
        
        if let array = dictionary["image"] as? NSArray{
            self.image = ServerImage.modelsFromDictionaryArray(array: array)
        }
        if let array = dictionary["categories"] as? Array<String>{
            var cats = Array<Int64>()
            for item in array{
                if let value = Int64.init(item){
                    cats.append(value)
                }
            }
            self.categories = cats
        }
    }
    
    
    static func < (lhs: Product, rhs: Product) -> Bool {
        guard let lc = lhs.category, let rc = rhs.category else {
            return lhs.category != nil ? true : false
            
        }
        return lc < rc
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
