//
//  RecipeImageTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 04/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipeImageTableViewCell: UITableViewCell {

    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var favoriteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
