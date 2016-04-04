//
//  RecipeDetailSectionHeaderTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 04/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipeDetailSectionHeaderTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateAdded: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var overallTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
