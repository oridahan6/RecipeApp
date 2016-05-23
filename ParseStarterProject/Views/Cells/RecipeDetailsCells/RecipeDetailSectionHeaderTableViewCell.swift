//
//  RecipeDetailSectionHeaderTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 04/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipeDetailSectionHeaderTableViewCell: UITableViewCell {

    var recipe: Recipe!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // draw again on orientation change
        self.contentMode = UIViewContentMode.Redraw
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func drawRect(rect: CGRect) {
        // Drawing code
        if let _ = self.recipe {
            self.drawRecipeDetails(self.recipe)
        }
    }
}
