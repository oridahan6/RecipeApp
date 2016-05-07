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

    //--------------------------------------
    // MARK: - get data methods
    //--------------------------------------

    func updateRecipes(vc: RecipesViewController) -> Void {
        
        vc.activityIndicator.show()
        
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
                    vc.activityIndicator.hide()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                vc.activityIndicator.hide()
            }
        }
    }
    
    func updateCategories(vc: CategoriesViewController) -> Void {

        vc.activityIndicator.show()
        
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
                    vc.activityIndicator.hide()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    func updateRecipesFromCategoryId(vc: RecipesViewController, catId: Int) -> Void {
        
        vc.activityIndicator.show()
        
        let query = PFQuery(className:"Recipe")
        query.whereKey("categories", equalTo:catId)
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
                    vc.activityIndicator.hide()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    func updateFavoriteRecipes(vc: FavoritesViewController, ids: [String]) -> Void {
                
        vc.beginUpdateView()
        
        let query = PFQuery(className:"Recipe")
        query.whereKey("objectId", containedIn: ids)
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
                    vc.endUpdateView()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    //--------------------------------------
    // MARK: - Submit Data
    //--------------------------------------

    func uploadRecipe(recipeData: [String: AnyObject]) -> Bool {
        /*
        let recipe = PFObject(className:"Recipe")
        recipe["title"] = recipeData["title"]
//        if let recipeImage = recipeData["image"] as? UIImage {
//            recipe["imageName"] = recipeImage.
//        }
        recipe["cheatMode"] = false
        recipe.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        */
        return false
    }
    
    //--------------------------------------
    // MARK: - user methods
    //--------------------------------------

    class func login(username: String, password: String, vc: LoginViewController) {
        
        vc.activityIndicator.show()
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                vc.activityIndicator.hide()

                vc.showSuccessAlert()
            } else {
                if let error = error {
                    print(error)
                    vc.activityIndicator.hide()
                    vc.showErrorAlert(error.code)
                }
            }
        }

    }
    
    class func currentUser() -> PFUser? {
        if let user = PFUser.currentUser() {
            return user
        }
        return nil
    }
    
    class func logOut() {
        PFUser.logOut()
    }
}
