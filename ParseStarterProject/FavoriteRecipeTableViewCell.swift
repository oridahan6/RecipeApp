//
//  FavoriteRecipeTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 06/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class FavoriteRecipeTableViewCell: UITableViewCell {

    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeDetailsView: RecipeDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
