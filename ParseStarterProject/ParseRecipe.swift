//
//  ParseRecipe.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseRecipe: NSObject {

    var recipe: PFObject!
    
    init(recipe: PFObject) {
        super.init()
        
        self.recipe = recipe
    }
    
    func getId() -> String {
        if let id = recipe.objectId {
            return id
        }
        return ""
    }

    func getAddedDate() -> NSDate {
        if let dateAdded = recipe.createdAt {
            return dateAdded
        }
        return NSDate()
    }

    func getTitle() -> String {
        if let title = recipe["title"] as? String {
            return title
        }
        return ""
    }
    
    func getDirections() -> [String] {
        if let directions = recipe["directions"] as? [String] {
            return directions
        }
        return []
    }

    func getIngredients() -> [String: [String]] {
        if let ingredients = recipe["ingredients"] as? [String: [String]] {
            return ingredients
        }
        return ["":[]]
    }
    
    func getCategories() -> [Int] {
        if let categories = recipe["categories"] as? [Int] {
            return categories
        }
        return []
    }
    
    func getLevel() -> String {
        if let level = recipe["level"] as? String {
            return level
        }
        return ""
    }
    
    func getCookTime() -> Int {
        if let cookTime = recipe["cookTime"] as? Int {
            return cookTime
        }
        return 0
    }
    
    func getPrepTime() -> Int {
        if let prepTime = recipe["prepTime"] as? Int {
            return prepTime
        }
        return 0
    }

    func getType() -> String {
        if let type = recipe["type"] as? String {
            return type
        }
        return ""
    }
    
    func getImageName() -> String {
        if let imageName = recipe["imageName"] as? String {
            return imageName
        }
        return ""
    }

}
