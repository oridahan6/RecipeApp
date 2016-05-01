//
//  AddIngredientTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 27/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddIngredientTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var ingredientAmountTextField: UITextField!
    @IBOutlet var ingredientTextTextField: UITextField!
    
    var tableViewController: AddRecipeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ingredientTextTextField.delegate = self
        self.ingredientAmountTextField.delegate = self
        self.ingredientTextTextField.tag = 0
        self.ingredientAmountTextField.tag = 0
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
        self.updateIngredientArray(textField)
    }
    
    //--------------------------------------
    // MARK: - helpers
    //--------------------------------------

    func updateIngredientArray(textField: UITextField) {
        var ingredientText = ""
        
        if let cell = textField.superview?.superview as? AddIngredientTableViewCell {
            //            print(cell.contentView)
            for (index, currentTextField) in cell.contentView.subviews.enumerate() {
                if let currentTextField = currentTextField as? UITextField {
                    if let text = currentTextField.text {
                        ingredientText += text
                    }
                }
                if index == 0 {
                    ingredientText += "|"
                }
            }
            
            print("ingredientText")
            print(ingredientText)
            
            let currentIngredientSection = self.tableViewController.currentIngredientSection
            
            if let indexPath = self.tableViewController.tableView.indexPathForCell(cell) {
                let currentRow = indexPath.row
                if var ingredientsArray = self.tableViewController.recipeIngredients[currentIngredientSection] {
                    print("currentRow")
                    print(currentRow)
                    print("array count")
                    print(ingredientsArray.count)
                    
//                    print("generalIngredientsArray[0]")
//                    print(generalIngredientsArray[0])
                    if let currentSectionRow = self.tableViewController.ingredientsEndPositionPerSection[currentIngredientSection] {
                        print("currentSectionRow")
                        print(currentSectionRow)

                        let currentIndex = currentRow - currentSectionRow
                        
                        print("currentIndex")
                        print(currentIndex)

                        
                        if ingredientsArray.count <= currentIndex {
                            print("in append")
                            ingredientsArray.append(ingredientText)
//                            self.tableViewController.ingredientsEndPositionPerSection[currentIngredientSection] = currentSectionRow + 1
                        } else {
                            print("in replace")
                            ingredientsArray[currentIndex] = ingredientText
                        }
                        print("ingredientsArray")
                        print(ingredientsArray)
                        self.tableViewController.recipeIngredients[self.tableViewController.currentIngredientSection] = ingredientsArray
                    }
                }
            }
        }
        
        print("self.tableViewController.recipeIngredients")
        print(self.tableViewController.recipeIngredients)
        
    }
}
