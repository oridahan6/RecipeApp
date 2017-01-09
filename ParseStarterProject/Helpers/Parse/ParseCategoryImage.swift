//
//  ParseCategoryImage.swift
//  Recipes
//
//  Created by Ori Dahan on 09/01/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseCategoryImage: NSObject {
    
    var categoryImage: PFObject!
    
    init(categoryImage: PFObject) {
        super.init()
        
        self.categoryImage = categoryImage
    }
    
    func getId() -> String {
        if let id = categoryImage.objectId {
            return id
        }
        return ""
    }
    
    func getCatId() -> Int {
        if let catId = categoryImage["catId"] as? Int {
            return catId
        }
        return 0
    }
    
    func getImageFile() -> ParseFile? {
        if let imageFile = categoryImage["image"] as? PFFile {
            return ParseFile(parseFile: imageFile)
        }
        return nil
    }
}
