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
    @IBOutlet var editButton: UIButton!
    
    var tableViewController: AddRecipeViewController!
    
    @IBAction func addLine(sender: AnyObject) {
        self.addLineBySection(sender.tag)
    }
    
    @IBAction func addSubSection(sender: AnyObject) {
        self.addLineBySection(sender.tag, addSection: true)
    }
    
    @IBAction func edit(sender: AnyObject) {
        let section = sender.tag
        
        if section == 3 {
            self.tableViewController.isIngredientEditing = !self.tableViewController.isIngredientEditing
        } else if section == 4 {
            self.tableViewController.isDirectionEditing = !self.tableViewController.isDirectionEditing
        }
        self.tableViewController.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .None)
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
            count = self.tableViewController.getRecipeIngredientsCount()
//            self.tableViewController.ingredientsArray.append(addSection ? "section" : "ingredient")
            self.tableViewController.recipeIngredients["general"]!.append("|")
        } else if section == 4 {
            count = self.tableViewController.getRecipeDirectionsCount()
//            self.tableViewController.directionsArray.append(addSection ? "section" : "direction")
            self.tableViewController.recipeDirections["general"]!.append("")
        }
        self.tableViewController.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: count, inSection: section)], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableViewController.tableView.endUpdates()
        
        // scroll to add direction button for convinience
        if section == 4 {
            self.scrollToEndOfSection(section)
        } else if section == 3, let win = UIApplication.sharedApplication().keyWindow {
            let buttonPointRelativeToWindow = self.convertRect(CGRectZero, toView: win)
            // scroll only if the add row button is closer to the bottom of the screen
            let percentageInWindow: CGFloat = buttonPointRelativeToWindow.origin.y / win.bounds.size.height
            if percentageInWindow > 0.8 {
                self.scrollToEndOfSection(section)
            }
        }

    }
    
    func scrollToEndOfSection(section: Int) {
        let indexPath = NSIndexPath(forRow: self.tableViewController.tableView.numberOfRowsInSection(section) - 1, inSection: section)
        self.tableViewController.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
}
