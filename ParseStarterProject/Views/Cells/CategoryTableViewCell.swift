//
//  CategoryTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 05/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var categoryNameLabel: UILabel!
    @IBOutlet var recipesCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
