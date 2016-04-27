//
//  AddRecipeButtonsTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 27/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddRecipeButtonsTableViewCell: UITableViewCell {

    var tableViewController: AddRecipeViewController!
    
    @IBAction func addLine(sender: AnyObject) {
        self.tableViewController.tableView.beginUpdates()
        self.tableViewController.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableViewController.ingredientsArray.count, inSection: 3)], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableViewController.ingredientsArray.append("ingredient")
        self.tableViewController.tableView.endUpdates()
    }
    
    @IBAction func addSubSection(sender: AnyObject) {
        self.tableViewController.tableView.beginUpdates()
        self.tableViewController.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableViewController.ingredientsArray.count, inSection: 3)], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableViewController.ingredientsArray.append("section")
        self.tableViewController.tableView.endUpdates()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
