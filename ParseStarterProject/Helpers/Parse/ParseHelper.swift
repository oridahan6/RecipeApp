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
    
    static let sharedInstance = ParseHelper()
    
    private override init() {}
    
    var allRecipes = [Recipe]()
    var allCategories = [Category]()

    // update dates
    var recipesLastFetched: NSDate!
    var categoriesLastFetched: NSDate!
    var recipesFromCategoryIdLastFetched = [String: NSDate]()
    var favoritesLastFetched: NSDate!
    
    // Parse class names
    let parseClassNameRecipe = "Recipe"
    let parseClassNameCategories = "Categories"
    
    //--------------------------------------
    // MARK: - get data methods
    //--------------------------------------
    
    func updateRecipes(vc: RecipesViewController) -> Void {
        
        let query = PFQuery(className: self.parseClassNameRecipe)
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
                self.allRecipes = vc.recipes
                if objects.count > 0 {
                    vc.endUpdateView()
                }
            }
        }
        func errorBlock () -> Void {
            vc.endUpdateView()
        }
        func updateViewBlock() -> Void {
            vc.beginUpdateView()
        }
        func extraNetworkSuccessBlock() -> Void {
            self.recipesLastFetched = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(self.recipesLastFetched, forKey: "recipesLastFetched")
        }
        
        if let recipesLastFetched = NSUserDefaults.standardUserDefaults().objectForKey("recipesLastFetched") as? NSDate {
            self.recipesLastFetched = recipesLastFetched
        }
        
        self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.recipesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock, updateViewBlock: updateViewBlock)
    }
    
    func updateCategories(vc: CategoriesViewController) -> Void {
        
        let query = PFQuery(className: self.parseClassNameCategories)
        query.orderByAscending("displayOrder")
        func successBlock (objects: [AnyObject]?) -> Void {
            if let objects = objects {
                vc.categories = [Category]()
                for object in objects {
                    if let object = object as? PFObject {
                        let parseCategory = ParseCategory(category: object)
                        if let category = Category(category: parseCategory) {
                            vc.categories.append(category)
                        }
                    }
                }
                self.allCategories = vc.categories
                if objects.count > 0 {
                    vc.endUpdateView()
                }
            }
        }
        func errorBlock () -> Void {
            vc.endUpdateView()
        }
        func updateViewBlock() -> Void {
            vc.beginUpdateView()
        }
        func extraNetworkSuccessBlock() -> Void {
            self.categoriesLastFetched = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(self.categoriesLastFetched, forKey: "categoriesLastFetched")
        }
        
        if let categoriesLastFetched = NSUserDefaults.standardUserDefaults().objectForKey("categoriesLastFetched") as? NSDate {
            self.categoriesLastFetched = categoriesLastFetched
        }

        self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.categoriesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock, updateViewBlock: updateViewBlock)
    }
    
    func updateCategories(addRecipe vc: AddRecipeViewController) -> Void {
        if allCategories.isEmpty {
            let query = PFQuery(className: self.parseClassNameCategories)
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
                    allCategories = vc.categories
                }
            }
            func extraNetworkSuccessBlock() -> Void {
                self.categoriesLastFetched = NSDate()
                NSUserDefaults.standardUserDefaults().setObject(self.categoriesLastFetched, forKey: "categoriesLastFetched")
            }

            if let categoriesLastFetched = NSUserDefaults.standardUserDefaults().objectForKey("categoriesLastFetched") as? NSDate {
                self.categoriesLastFetched = categoriesLastFetched
            }

            self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.categoriesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock)
        } else {
            vc.categories = allCategories
        }
    }
    
    func updateRecipesFromCategoryId(vc: RecipesViewController, catId: Int) -> Void {
        
        let query = PFQuery(className: self.parseClassNameRecipe)
        
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
        func updateViewBlock() -> Void {
            vc.beginUpdateView()
        }
        func extraNetworkSuccessBlock() -> Void {
            self.recipesFromCategoryIdLastFetched[String(catId)] = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(self.recipesFromCategoryIdLastFetched, forKey: "recipesFromCategoryIdLastFetched")
        }

        if let recipesFromCategoriesIdLastFetched = NSUserDefaults.standardUserDefaults().objectForKey("recipesFromCategoryIdLastFetched") as? [String: NSDate] {
            self.recipesFromCategoryIdLastFetched[String(catId)] = recipesFromCategoriesIdLastFetched[String(catId)]
        }

        self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.recipesFromCategoryIdLastFetched[String(catId)], successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock, updateViewBlock: updateViewBlock)
    }
    
    func updateFavoriteRecipes(vc: FavoritesViewController, ids: [String]) -> Void {
        
        if allRecipes.isEmpty {
            let query = PFQuery(className: self.parseClassNameRecipe)
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
            func updateViewBlock() -> Void {
                vc.beginUpdateView()
            }
            func extraNetworkSuccessBlock() -> Void {
                self.favoritesLastFetched = NSDate()
                NSUserDefaults.standardUserDefaults().setObject(self.favoritesLastFetched, forKey: "favoritesLastFetched")
            }
            if let favoritesLastFetched = NSUserDefaults.standardUserDefaults().objectForKey("favoritesLastFetched") as? NSDate {
                self.favoritesLastFetched = favoritesLastFetched
            }

            self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.favoritesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock)
        } else {
            vc.recipes = allRecipes.filter({ (recipe) -> Bool in
                return ids.contains(recipe.id)
            })
        }
    }
    
    //--------------------------------------
    // MARK: - Submit Data
    //--------------------------------------
    
    func uploadRecipe(recipeData: [String: AnyObject], vc: AddRecipeViewController) -> Bool {
        
        vc.showActivityIndicator()
        
        let recipe = PFObject(className: self.parseClassNameRecipe)
        if let title = recipeData["title"] as? String, recipeImage = recipeData["image"] as? UIImage, imageData = UIImagePNGRepresentation(recipeImage), level = recipeData["level"] as? String, type = recipeData["type"] as? String, prepTime = recipeData["prepTime"] as? Int, cookTime = recipeData["cookTime"] as? Int, ingredients = recipeData["ingredients"] as? [String: [String]], directions = recipeData["directions"] as? [String: [String]] {
            recipe.setValue(title, forKey: "title")
            let imageFile = PFFile(name: Helpers.randomStringWithLength(10) + ".png", data: imageData)
            recipe.setObject(imageFile, forKey: "image")
            recipe.setValue(level, forKey: "level")
            recipe.setValue(type, forKey: "type")
            
            var categoriesIds = [String]()
            var categoriesCatIds = [Int]()
            if let categories = recipeData["categories"] as? [Category] {
                for category in categories {
                    categoriesIds.append(category.id)
                    categoriesCatIds.append(category.catId)
                }
            }
            
            recipe.setObject(categoriesCatIds, forKey: "categories")
            
            recipe.setValue(prepTime, forKey: "prepTime")
            recipe.setValue(cookTime, forKey: "cookTime")
            recipe.setObject(ingredients, forKey: "ingredients")
            recipe.setObject(directions, forKey: "directions")
            
            recipe.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    vc.handlePostSuccess()
                    self.updateCategoriesRecipesCount(categoriesIds)
                    
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
    
    private func updateCategoriesRecipesCount(ids: [String]) {
        let query = PFQuery(className: self.parseClassNameCategories)
        query.whereKey("objectId", containedIn: ids)
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) in
            if (error == nil) {
                if let categories = objects {
                    for category in categories {
                        category.incrementKey("recipesCount")
                    }
                    PFObject.saveAllInBackground(categories, block: { (success, error) in
                        if !success || error != nil {
                            print("Saving categories' recipes count failed")
                        }
                    })
                }
            } else {
                print("Fetch categories failed")
            }
        })
    }
    
    private func findObjectsLocallyThenRemotely(query: PFQuery!, lastUpdateDate: NSDate?, successBlock:[AnyObject]! -> Void, extraNetworkSuccessBlock:Void -> Void = {}, errorBlock:Void -> Void = {}, updateViewBlock:Void -> Void = {}) {
        
        let localQuery = (query.copy() as! PFQuery).fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock({ (localObjects, error) -> Void in
            if (error == nil) {
                if localObjects?.count > 0 {
//                    print("Success : Local Query: \(query.parseClassName)")
                    successBlock(localObjects)
                } else {
                    updateViewBlock()
                }
            } else {
                print("Error : Local Query: \(query.parseClassName)")
            }
            
            let dateQuery = (query.copy() as! PFQuery)
            
            // Check if class was updated before unpinning and pinning new objects
            if let lastUpdateDate = lastUpdateDate {
                dateQuery.whereKey("updatedAt", greaterThan: lastUpdateDate)
            }
            dateQuery.getFirstObjectInBackgroundWithBlock({ (first, error) -> Void in
                if error == nil {
                    // something was updated after lastUpdateDate
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if(error == nil) {
//                            print("Success : Network Query: \(query.parseClassName)")
                            PFObject.unpinAllInBackground(localObjects, block: { (success, error) -> Void in
                                if (error == nil) {
//                                    print("Success : Unpin Local Query: \(query.parseClassName)")
                                    extraNetworkSuccessBlock()
                                    PFObject.pinAllInBackground(objects, block: { (success, error) -> Void in
                                        if (error == nil) {
//                                            print("Success : Pin Query Result: \(query.parseClassName)")
                                            successBlock(objects)
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
                } else if error?.code == 101 {
                    // nothing was updated after lastUpdateDate
//                    print("Error: nothing was updated!")
                } else {
                    // something went wrong
                    print("Error: Something went wrong")
                }
            })
        })
        
    }
    
}
