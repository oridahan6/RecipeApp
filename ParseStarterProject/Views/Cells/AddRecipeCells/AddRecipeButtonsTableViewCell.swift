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
    
    @IBAction func addLine(_ sender: AnyObject) {
        self.addLineBySection(sender.tag)
    }
    
    @IBAction func addSubSection(_ sender: AnyObject) {
        self.addLineBySection(sender.tag, addSection: true)
    }
    
    @IBAction func edit(_ sender: AnyObject) {
        let section = sender.tag
        
        if section == 3 {
            self.tableViewController.isIngredientEditing = !self.tableViewController.isIngredientEditing
        } else if section == 4 {
            self.tableViewController.isDirectionEditing = !self.tableViewController.isDirectionEditing
        }
        self.tableViewController.tableView.reloadSections(IndexSet(integer: section!), with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------
    // MARK: - helpers
    //--------------------------------------

    func addLineBySection(_ section: Int, addSection: Bool = false) {
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
        self.tableViewController.tableView.insertRows(at: [IndexPath(row: count, section: section)], with: UITableViewRowAnimation.fade)
        self.tableViewController.tableView.endUpdates()
        
        // scroll to add direction button for convinience
        if section == 4 {
            self.scrollToEndOfSection(section)
        } else if section == 3, let win = UIApplication.shared.keyWindow {
            let buttonPointRelativeToWindow = self.convert(CGRect.zero, to: win)
            // scroll only if the add row button is closer to the bottom of the screen
            let percentageInWindow: CGFloat = buttonPointRelativeToWindow.origin.y / win.bounds.size.height
            if percentageInWindow > 0.8 {
                self.scrollToEndOfSection(section)
            }
        }

    }
    
    func scrollToEndOfSection(_ section: Int) {
        let indexPath = IndexPath(row: self.tableViewController.tableView.numberOfRows(inSection: section) - 1, section: section)
        self.tableViewController.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
}
