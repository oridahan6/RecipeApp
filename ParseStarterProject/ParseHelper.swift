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
        let query = PFQuery(className:"Recipe")
        query.orderByDescending("updatedAt")
        func successBlock (objects: [AnyObject]?) -> Void {
            if let objects = objects {
                vc.recipes = [Recipe]()
                for object in objects {
                    if let object = object as? PFObject {
                        let parseRecipe = ParseRecipe(recipe: object)
                        if let recipe = Recipe(recipe: parseRecipe) {
                            vc.recipes.append(recipe)
                        }
                    }
                }
                if objects.count > 0 {
                    vc.endUpdateView()
                }
            }
        }
        func errorBlock () -> Void {
            vc.endUpdateView()
        }
        
        self.findObjectsLocallyThenRemotely(query, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    func updateCategories(vc: CategoriesViewController) -> Void {
        
        vc.activityIndicator.show()
        
        let query = PFQuery(className:"Categories")
        func successBlock (objects: [AnyObject]?) -> Void {
            if let objects = objects {
                for object in objects {
                    if let object = object as? PFObject {
                        let parseCategory = ParseCategory(category: object)
                        if let category = Category(category: parseCategory) {
                            vc.categories.append(category)
                        }
                    }
                }
                if objects.count > 0 {
                    vc.activityIndicator.hide()
                }
            }
        }
        func errorBlock () -> Void {
            vc.activityIndicator.hide()
        }
        
        self.findObjectsLocallyThenRemotely(query, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    func updateCategories(addRecipe vc: AddRecipeViewController) -> Void {
        
        let query = PFQuery(className:"Categories")
        func successBlock (objects: [AnyObject]?) -> Void {
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
        }
        self.findObjectsLocallyThenRemotely(query, successBlock: successBlock, errorBlock: {})
    }
    
    func updateRecipesFromCategoryId(vc: RecipesViewController, catId: Int) -> Void {
        
        let query = PFQuery(className:"Recipe")
        
        if let updatedAt = vc.updatedAt {
            query.whereKey("updatedAt", greaterThan: updatedAt)
        }
        
        query.whereKey("categories", equalTo:catId)
        query.orderByDescending("updatedAt")
        func successBlock (objects: [AnyObject]?) -> Void {
            if let objects = objects {
                vc.recipes = [Recipe]()
                for object in objects {
                    if let object = object as? PFObject {
                        let parseRecipe = ParseRecipe(recipe: object)
                        if let recipe = Recipe(recipe: parseRecipe) {
                            vc.recipes.append(recipe)
                        }
                    }
                }
                if objects.count > 0 {
                    vc.endUpdateView()
                }
            }
        }
        func errorBlock () -> Void {
            vc.endUpdateView()
        }

        self.findObjectsLocallyThenRemotely(query, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    func updateFavoriteRecipes(vc: FavoritesViewController, ids: [String]) -> Void {
        
        vc.beginUpdateView()
        let query = PFQuery(className:"Recipe")
        query.whereKey("objectId", containedIn: ids)
        
        func successBlock (objects: [AnyObject]?) -> Void {
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
        }
        func errorBlock () -> Void {
            vc.endUpdateView()
        }

        self.findObjectsLocallyThenRemotely(query, successBlock: successBlock, errorBlock: errorBlock)
    }

    //--------------------------------------
    // MARK: - Submit Data
    //--------------------------------------

    func uploadRecipe(recipeData: [String: AnyObject], vc: AddRecipeViewController) -> Bool {
        
        vc.showActivityIndicator()
        
        let recipe = PFObject(className:"Recipe")
        if let title = recipeData["title"] as? String, recipeImage = recipeData["image"] as? UIImage, imageData = UIImagePNGRepresentation(recipeImage), level = recipeData["level"] as? String, type = recipeData["type"] as? String, prepTime = recipeData["prepTime"] as? Int, cookTime = recipeData["cookTime"] as? Int, ingredients = recipeData["ingredients"] as? [String: [String]], directions = recipeData["directions"] as? [String: [String]] {
            recipe.setValue(title, forKey: "title")
            let imageFile = PFFile(name: Helpers.randomStringWithLength(10) + ".png", data: imageData)
            recipe.setObject(imageFile, forKey: "image")
            recipe.setValue(level, forKey: "level")
            recipe.setValue(type, forKey: "type")
            
            var categoriesIds = [Int]()
            if let categories = recipeData["categories"] as? [Category] {
                for category in categories {
                    categoriesIds.append(category.catId)
                }
            }
            
            recipe.setObject(categoriesIds, forKey: "categories")
            
            recipe.setValue(prepTime, forKey: "prepTime")
            recipe.setValue(cookTime, forKey: "cookTime")
            recipe.setObject(ingredients, forKey: "ingredients")
            recipe.setObject(directions, forKey: "directions")
            
            recipe.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    
                    print("success")
                    
                    vc.hideActivityIndicator()
                    vc.showSuccessAlert()
                    
                } else {
                    // There was a problem, check error.description
                    
                    vc.hideActivityIndicator()
                    if let error = error {
                        vc.showErrorAlert(error.code)
                    } else {
                        vc.showErrorAlert()
                    }
                }
            }

        }
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
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    private func findObjectsLocallyThenRemotely(query: PFQuery!, successBlock:[AnyObject]! -> Void, errorBlock:Void -> Void) {
        let localQuery = (query.copy() as! PFQuery).fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock({ (localObjects, error) -> Void in
            if (error == nil) {
                if localObjects?.count > 0 {
                    print("Success : Local Query: \(query.parseClassName)")
                    successBlock(localObjects)
                }
            } else {
                print("Error : Local Query: \(query.parseClassName)")
            }
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if(error == nil) {
                    print("Success : Network Query: \(query.parseClassName)")
                    PFObject.unpinAllInBackground(localObjects, block: { (success, error) -> Void in
                        if (error == nil) {
                            
                            if localObjects?.count == 0 || localObjects?.count < objects?.count {
                                print("Success : Unpin Local Query: \(query.parseClassName)")
                                successBlock(objects)
                            }
                            
                            PFObject.pinAllInBackground(objects, block: { (success, error) -> Void in
                                if (error == nil) {
                                    print("Success : Pin Query Result: \(query.parseClassName)")
                                } else {
                                    print("Error : Pin Query Result: \(query.parseClassName)")
                                }
                            })
                        } else {
                            print("Error : Unpin Local Query: \(query.parseClassName)")
                        }
                    })
                } else {
                    print("Error : Network Query: \(query.parseClassName)")
                }
            })
        })
        
    }

}
