//
//  GeneralInfoTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 21/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class GeneralInfoTableViewCell: UITableViewCell {

    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let levelTap = UITapGestureRecognizer(target: self, action: #selector(GeneralInfoTableViewCell.levelLabelTapped))
        self.levelLabel.addGestureRecognizer(levelTap)
        let typeTap = UITapGestureRecognizer(target: self, action: #selector(GeneralInfoTableViewCell.typeLabelTapped))
        self.typeLabel.addGestureRecognizer(typeTap)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func levelLabelTapped(sender: UITapGestureRecognizer? = nil) {
        print("level")
    }

    func typeLabelTapped(sender: UITapGestureRecognizer? = nil) {
        print("type")
    }

}
