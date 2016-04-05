//
//  ParseHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseHelper: NSObject {

    func updateRecipes(vc: RecipesViewController) -> Void {
        let query = PFQuery(className:"Recipe")
        //        query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) recipes.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if let object = object as? PFObject {
                            let parseRecipe = ParseRecipe(recipe: object)
                            if let recipe = Recipe(recipe: parseRecipe) {
                                vc.recipes.append(recipe)
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func updateCategories(vc: CategoriesViewController) -> Void {

        let query = PFQuery(className:"Categories")
        //        query.whereKey("playerName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) categories.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if let object = object as? PFObject {
                            let parseCategory = ParseCategory(category: object)
                            if let category = Category(category: parseCategory) {
                                vc.categories.append(category)
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
}
