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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let tableVC = self.tableViewController {
            if tableVC.isIngredientEditing {
                var frame = self.contentView.frame
                frame.size.width = frame.size.width + 38

                self.contentView.frame = frame
            }
        }

        self.ingredientTextTextField.addBottomBorder()
        self.ingredientAmountTextField.addBottomBorder()
        
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
            
            let currentIngredientSection = self.tableViewController.currentIngredientSection
            
            if let indexPath = self.tableViewController.tableView.indexPathForCell(cell) {
                let currentRow = indexPath.row
                if var ingredientsArray = self.tableViewController.recipeIngredients[currentIngredientSection] {
                    if let currentSectionIndexes = self.tableViewController.ingredientsEndPositionPerSection[currentIngredientSection] {

                        let currentIndex = currentRow - currentSectionIndexes[0]
                        
                        if ingredientsArray.count <= currentIndex {
                            ingredientsArray.append(ingredientText)
                            if var currentSectionIndexes = self.tableViewController.ingredientsEndPositionPerSection[self.tableViewController.currentIngredientSection] {
                                currentSectionIndexes[1] = currentRow
                                self.tableViewController.ingredientsEndPositionPerSection[self.tableViewController.currentIngredientSection] = currentSectionIndexes
                            }
                        } else {
                            ingredientsArray[currentIndex] = ingredientText
                        }
                        self.tableViewController.recipeIngredients[self.tableViewController.currentIngredientSection] = ingredientsArray
                    }
                }
            }
        }
    }
    
    /* move reorder control to left size
     override func layoutSubviews() {
     
     super.layoutSubviews()
     
     self.contentView.frame = CGRectMake(32,
     self.contentView.frame.origin.y,
     self.contentView.frame.size.width + 8,
     self.contentView.frame.size.height);
     
     
     var subviews: [UIView] = []
     subviews += self.subviews
     for view in self.subviews {
     let firstLevelView = view
     if firstLevelView.subviews.count > 0 {
     subviews += firstLevelView.subviews
     }
     }
     
     for view in subviews {
     //            print(view.classForCoder.description())
     if view.classForCoder.description() == "UITableViewCellReorderControl" {
     let reorderControl = view
     let resizedReorderControl = UIView(frame: CGRectMake(0, 0, CGRectGetMaxX(reorderControl.frame), CGRectGetMaxY(reorderControl.frame)))
     
     resizedReorderControl.addSubview(reorderControl)
     self.addSubview(resizedReorderControl)
     
     let moveLeft: CGSize = CGSizeMake(resizedReorderControl.frame.size.width - reorderControl.frame.size.width, resizedReorderControl.frame.size.height - reorderControl.frame.size.height);
     transform = CGAffineTransformIdentity;
     transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
     
     //
     //                let sizeDifference = CGSizeMake(resizedReorderControl.frame.size.width - reorderControl.frame.size.width, resizedReorderControl.frame.size.height - reorderControl.frame.size.height)
     //                let transformRatio = CGSizeMake(resizedReorderControl.frame.size.width / reorderControl.frame.size.width, resizedReorderControl.frame.size.height / reorderControl.frame.size.height)
     //
     //                var transform = CGAffineTransformIdentity
     //
     //                transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height)
     //                transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2, -sizeDifference.height / 2)
     //
     //                resizedReorderControl.transform = transform
     }
     }
     
     
     }
     */

}
