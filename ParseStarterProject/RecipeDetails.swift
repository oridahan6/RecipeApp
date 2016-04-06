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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
