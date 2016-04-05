//
//  Category.swift
//  Recipes
//
//  Created by Ori Dahan on 05/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    var id: String = ""
    var catId: Int!
    var name: String!
    var recipes = [Recipe]()
    var imageName: String = ""
    
    // MARK: - Init Methods
    init?(category: ParseCategory) {
        super.init()
        
        self.id = category.getId()
        self.catId = category.getCatId()
        self.name = category.getName()
//        self.recipes = category.getRecipes()
        self.imageName = category.getImageName()
        
        if id.isEmpty || name.isEmpty {
            return nil
        }
    }

}