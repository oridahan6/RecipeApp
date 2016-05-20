//
//  AddIngredientSectionTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 27/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddIngredientSectionTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var ingredientSectionTextField: UITextField!
    
    var tableViewController: AddRecipeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.ingredientSectionTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if let sectionText = textField.text {
            self.tableViewController.recipeIngredients[sectionText] = []
            if let cell = textField.superview?.superview as? AddIngredientSectionTableViewCell {
                if let indexPath = self.tableViewController.tableView.indexPathForCell(cell) {
                    let currentRow = indexPath.row
                    // set previous section
                    var previousIngredientsEndPositionPerSection = self.tableViewController.ingredientsEndPositionPerSection[self.tableViewController.currentIngredientSection]
                    previousIngredientsEndPositionPerSection![1] = currentRow - 1
                    self.tableViewController.ingredientsEndPositionPerSection[self.tableViewController.currentIngredientSection] = previousIngredientsEndPositionPerSection
                    // set new section
                    var newIngredientsEndPositionPerSection: [Int] = []
                    newIngredientsEndPositionPerSection.append(currentRow + 1)
                    newIngredientsEndPositionPerSection.append(currentRow + 1)
                    self.tableViewController.ingredientsEndPositionPerSection[sectionText] = newIngredientsEndPositionPerSection
                    
                }
            }
            self.tableViewController.currentIngredientSection = sectionText
        }
    }
    
}
