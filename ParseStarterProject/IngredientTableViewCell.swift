//
//  IngredientTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 31/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet var ingredientLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
