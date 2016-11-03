//
//  ParseHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ParseHelper: NSObject {
    
    static let sharedInstance = ParseHelper()
    
    fileprivate override init() {}
    
    var allRecipes = [Recipe]()
    var allCategories = [Category]()

    // update dates
    var recipesLastFetched: Date!
    var categoriesLastFetched: Date!
    var recipesFromCategoryIdLastFetched = [String: Date]()
    var favoritesLastFetched: Date!
    
    // Parse class names
    let parseClassNameRecipe = "Recipe"
    let parseClassNameCategories = "Categories"
    
    //--------------------------------------
    // MARK: - get data methods
    //--------------------------------------
    
    func updateRecipes(_ vc: RecipesViewController) -> Void {
        
        let query = PFQuery(className: self.parseClassNameRecipe)
        query.order(byDescending: "updatedAt")
        func successBlock (_ objects: [AnyObject]?) -> Void {
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
            self.recipesLastFetched = Date()
            UserDefaults.standard.set(self.recipesLastFetched, forKey: "recipesLastFetched")
        }
        
        if let recipesLastFetched = UserDefaults.standard.object(forKey: "recipesLastFetched") as? Date {
            self.recipesLastFetched = recipesLastFetched
        }
        
        self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.recipesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock, updateViewBlock: updateViewBlock)
    }
    
    func updateCategories(_ vc: CategoriesViewController) -> Void {
        
        let query = PFQuery(className: self.parseClassNameCategories)
        query.order(byAscending: "displayOrder")
        func successBlock (_ objects: [AnyObject]?) -> Void {
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
            self.categoriesLastFetched = Date()
            UserDefaults.standard.set(self.categoriesLastFetched, forKey: "categoriesLastFetched")
        }
        
        if let categoriesLastFetched = UserDefaults.standard.object(forKey: "categoriesLastFetched") as? Date {
            self.categoriesLastFetched = categoriesLastFetched
        }

        self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.categoriesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock, updateViewBlock: updateViewBlock)
    }
    
    func updateCategories(addRecipe vc: AddRecipeViewController) -> Void {
        if allCategories.isEmpty {
            let query = PFQuery(className: self.parseClassNameCategories)
            func successBlock (_ objects: [AnyObject]?) -> Void {
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
                self.categoriesLastFetched = Date()
                UserDefaults.standard.set(self.categoriesLastFetched, forKey: "categoriesLastFetched")
            }

            if let categoriesLastFetched = UserDefaults.standard.object(forKey: "categoriesLastFetched") as? Date {
                self.categoriesLastFetched = categoriesLastFetched
            }

            self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.categoriesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock)
        } else {
            vc.categories = allCategories
        }
    }
    
    func updateRecipesFromCategoryId(_ vc: RecipesViewController, catId: Int) -> Void {
        
        let query = PFQuery(className: self.parseClassNameRecipe)
        
        if let updatedAt = vc.updatedAt {
            query.whereKey("updatedAt", greaterThan: updatedAt)
        }
        
        query.whereKey("categories", equalTo:catId)
        query.order(byDescending: "updatedAt")
        func successBlock (_ objects: [AnyObject]?) -> Void {
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
            self.recipesFromCategoryIdLastFetched[String(catId)] = Date()
            UserDefaults.standard.set(self.recipesFromCategoryIdLastFetched, forKey: "recipesFromCategoryIdLastFetched")
        }

        if let recipesFromCategoriesIdLastFetched = UserDefaults.standard.object(forKey: "recipesFromCategoryIdLastFetched") as? [String: Date] {
            self.recipesFromCategoryIdLastFetched[String(catId)] = recipesFromCategoriesIdLastFetched[String(catId)]
        }

        self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.recipesFromCategoryIdLastFetched[String(catId)], successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock, updateViewBlock: updateViewBlock)
    }
    
    func updateFavoriteRecipes(_ vc: FavoritesViewController, ids: [String]) -> Void {

        if allRecipes.isEmpty {
            let query = PFQuery(className: self.parseClassNameRecipe)
            query.whereKey("objectId", containedIn: ids)
            
            func successBlock (_ objects: [AnyObject]?) -> Void {
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
                self.favoritesLastFetched = Date()
                UserDefaults.standard.set(self.favoritesLastFetched, forKey: "favoritesLastFetched")
            }
            if let favoritesLastFetched = UserDefaults.standard.object(forKey: "favoritesLastFetched") as? Date {
                self.favoritesLastFetched = favoritesLastFetched
            }

            self.findObjectsLocallyThenRemotely(query, lastUpdateDate: self.favoritesLastFetched, successBlock: successBlock, extraNetworkSuccessBlock: extraNetworkSuccessBlock, errorBlock: errorBlock)
        } else {
            vc.recipes = allRecipes.filter({ (recipe) -> Bool in
                return ids.contains(recipe.id)
            })
            
            // sort recipes by addition order
            vc.recipes.sort(by: { ids.index(of: $0.id) > ids.index(of: $1.id) })
        }
    }
    
    //--------------------------------------
    // MARK: - Submit Data
    //--------------------------------------
    
    func uploadRecipe(_ recipeData: [String: AnyObject], vc: AddRecipeViewController) -> Bool {
        
        vc.showActivityIndicator()
        
        let recipe = PFObject(className: self.parseClassNameRecipe)
        if let title = recipeData["title"] as? String, let recipeImage = recipeData["image"] as? UIImage, let imageData = UIImagePNGRepresentation(recipeImage), let level = recipeData["level"] as? String, let type = recipeData["type"] as? String, let prepTime = recipeData["prepTime"] as? Int, let cookTime = recipeData["cookTime"] as? Int, let ingredients = recipeData["ingredients"] as? [String: [String]], let directions = recipeData["directions"] as? [String: [String]] {
            recipe.setValue(title, forKey: "title")
            let imageFile = PFFile(name: Helpers.sharedInstance.randomStringWithLength(10) + ".png", data: imageData)
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
            
            recipe.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (success) {
                    // The object has been saved.
                    vc.handlePostSuccess()
                    self.updateCategoriesRecipesCount(categoriesIds)
                    
                } else {
                    // There was a problem, check error.description
                    
                    vc.hideActivityIndicator()
                    if let error = error {
                        vc.showErrorAlert(error._code)
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
    
    class func login(_ username: String, password: String, vc: LoginViewController) {

        vc.beginUpdateView()
        
        PFUser.logInWithUsername(inBackground: username, password: password) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                vc.showSuccessAlert()
            } else {
                if let error = error {
                    print(error)
                    vc.showErrorAlert(error._code)
                }
            }
            vc.endUpdateView()
        }
        
    }
    
    class func currentUser() -> PFUser? {
        if let user = PFUser.current() {
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
    
    fileprivate func updateCategoriesRecipesCount(_ ids: [String]) {
        let query = PFQuery(className: self.parseClassNameCategories)
        query.whereKey("objectId", containedIn: ids)
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                if let categories = objects as? [PFObject] {
                    for category in categories {
                        category.incrementKey("recipesCount")
                    }
                    PFObject.saveAll(inBackground: categories, block: { (success, error) in
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
    
    fileprivate func findObjectsLocallyThenRemotely(_ query: PFQuery!, lastUpdateDate: Date?, successBlock:@escaping ([AnyObject]!) -> Void, extraNetworkSuccessBlock:@escaping (Void) -> Void = {}, errorBlock:(Void) -> Void = {}, updateViewBlock:@escaping (Void) -> Void = {}) {
        
        let localQuery = (query.copy() as! PFQuery).fromLocalDatastore()
        localQuery.findObjectsInBackground(block: { (localObjects, error) -> Void in
            if (error == nil) {
                if localObjects?.count > 0 {
//                    print("Success : Local Query: \(query.parseClassName)")
                    successBlock(localObjects as [AnyObject]!)
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
            dateQuery.getFirstObjectInBackground(block: { (first, error) -> Void in
                if error == nil {
                    // something was updated after lastUpdateDate
                    query.findObjectsInBackground(block: { (objects, error) -> Void in
                        if(error == nil) {
//                            print("Success : Network Query: \(query.parseClassName)")
                            PFObject.unpinAll(inBackground: localObjects, block: { (success, error) -> Void in
                                if (error == nil) {
//                                    print("Success : Unpin Local Query: \(query.parseClassName)")
                                    extraNetworkSuccessBlock()
                                    PFObject.pinAll(inBackground: objects, block: { (success, error) -> Void in
                                        if (error == nil) {
//                                            print("Success : Pin Query Result: \(query.parseClassName)")
                                            successBlock(objects as [AnyObject]!)
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
                } else if error?._code == 101 {
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
