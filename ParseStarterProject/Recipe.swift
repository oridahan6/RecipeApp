//
//  Recipe.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Recipe: NSObject {

    var id: String = ""
    var dateAdded: NSDate!
    var title: String!
    var directions: [String: [String]]!
    var ingredients: [String: [String]]!
    var categories = [Int]()
    var level: String!
    var cookTime: Int = 0
    var prepTime: Int = 0
    var type: String = ""
    var imageName: String = ""
    
    //--------------------------------------
    // MARK: - Printable
    //--------------------------------------
    override var description: String {
        return "Recipe - title: \(self.title), id: \(self.id)"
    }
    
    //--------------------------------------
    // MARK: - Init Methods
    //--------------------------------------

    init?(recipe: ParseRecipe) {
        super.init()

        self.id = recipe.getId()
        self.dateAdded = recipe.getAddedDate()
        self.title = recipe.getTitle()
        self.directions = recipe.getDirections()
        self.ingredients = recipe.getIngredients()
        self.categories = recipe.getCategories()
        self.level = recipe.getLevel()
        self.cookTime = recipe.getCookTime()
        self.prepTime = recipe.getPrepTime()
        self.type = recipe.getType()
        self.imageName = recipe.getImageName()

        if id.isEmpty || title.isEmpty || directions.isEmpty || ingredients.isEmpty || level.isEmpty || type.isEmpty {
            return nil
        }
    }
    
    // MARK: - Helper Methods
    
    func getOverallPreperationTime() -> Int {
        return self.cookTime + self.prepTime
    }

    func getOverallPreperationTimeText() -> String {
        return Helpers().convertMinutesToHoursAndMinText(self.getOverallPreperationTime())
    }

    func getPreperationTimeText() -> String {
        return Helpers().convertMinutesToHoursAndMinText(self.prepTime)
    }

    func getCookTimeText() -> String {
        return Helpers().convertMinutesToHoursAndMinText(self.cookTime)
    }

    func getDateAddedDiff() -> String {
        return getLocalizedString("before") + " " + NSDate().offsetFrom(self.dateAdded)
    }
    
}
