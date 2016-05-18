//
//  AddRecipeButtonsTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 27/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddRecipeButtonsTableViewCell: UITableViewCell {

    @IBOutlet var addTextButton: UIButton!
    @IBOutlet var addSectionButton: UIButton!
    
    var tableViewController: AddRecipeViewController!
    
    @IBAction func addLine(sender: AnyObject) {
        self.addLineBySection(sender.tag)
    }
    
    @IBAction func addSubSection(sender: AnyObject) {
        self.addLineBySection(sender.tag, addSection: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------
    // MARK: - helpers
    //--------------------------------------

    func addLineBySection(section: Int, addSection: Bool = false) {
        self.tableViewController.tableView.beginUpdates()

        var count = 0
        if section == 3 {
            count = self.tableViewController.ingredientsArray.count
            self.tableViewController.ingredientsArray.append(addSection ? "section" : "ingredient")
            self.tableViewController.recipeIngredients["general"]!.append("|")
        } else if section == 4 {
            count = self.tableViewController.directionsArray.count
            self.tableViewController.directionsArray.append(addSection ? "section" : "direction")
            self.tableViewController.recipeDirections["general"]!.append("")
        }
        self.tableViewController.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: count, inSection: section)], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableViewController.tableView.endUpdates()
    }
}
