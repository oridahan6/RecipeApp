//
//  RecipeTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 28/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var dateAdded: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var overallTime: UILabel!
    @IBOutlet var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
