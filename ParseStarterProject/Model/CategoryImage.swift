//
//  CategoryImage.swift
//  Recipes
//
//  Created by Ori Dahan on 09/01/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class CategoryImage: NSObject {
    
    var id: String!
    var catId: Int!
    var imageFile: ParseFile!
    
    // MARK: - Init Methods
    init?(categoryImage: ParseCategoryImage) {
        super.init()
        
        self.id = categoryImage.getId()
        self.catId = categoryImage.getCatId()
        self.imageFile = categoryImage.getImageFile()

        if id.isEmpty || catId == nil {
            return nil
        }
    }
    
}
