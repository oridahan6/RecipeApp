//
//  RecipeDetails.swift
//  Recipes
//
//  Created by Ori Dahan on 28/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipeDetails: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateAddedLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var overallTimeLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var typeImageView: UIImageView!
    
    var recipe: Recipe!
    var isShowDate = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // draw again on orientation change
        self.contentMode = UIViewContentMode.redraw
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let _ = self.recipe {
            self.drawRecipeDetails(self.recipe, isShowDate: self.isShowDate)
        }
    }
}
