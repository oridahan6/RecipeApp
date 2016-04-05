//
//  ParseCategory.swift
//  Recipes
//
//  Created by Ori Dahan on 05/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseCategory: NSObject {
    
    var category: PFObject!
    
    init(category: PFObject) {
        super.init()
        
        self.category = category
    }
    
    func getId() -> String {
        if let id = category.objectId {
            return id
        }
        return ""
    }
    
    func getName() -> String {
        if let name = category["name"] as? String {
            return name
        }
        return ""
    }
    
    func getCatId() -> Int {
        if let catId = category["catId"] as? Int {
            return catId
        }
        return 0
    }
    
    func getImageName() -> String {
        if let imageName = category["imageName"] as? String {
            return imageName
        }
        return ""
    }
}