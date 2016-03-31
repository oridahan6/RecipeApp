//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 31/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateAdded: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var overallTime: UILabel!
    @IBOutlet var type: UILabel!
    
    var recipe: Recipe!
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = recipe.title
        self.type.text = recipe.type
        self.level.text = recipe.level
        self.overallTime.text = recipe.getOverallPreperationTimeText()
        self.dateAdded.text = recipe.getDateAddedDiff()
        
        // update image async
        let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
        Helpers().updateImageFromUrlAsync(imageUrlString, imageViewToUpdate: self.recipeImageView)

        
    }
    
}
