//
//  AddDirectionTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 01/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddDirectionTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var directionTextField: UITextField!
    
    var tableViewController: AddRecipeViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.directionTextField.delegate = self
        self.directionTextField.tag = 0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.contentView.frame
        frame.size.width = frame.size.width + 38
        
        self.contentView.frame = frame

        self.directionTextField.addBottomBorder()
    }
    

    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.updateDirectionsArray(textField)
    }
    
    //--------------------------------------
    // MARK: - helpers
    //--------------------------------------
    
    // not supporting sections yet
    func updateDirectionsArray(textField: UITextField) {
        
        if let directionText = textField.text, let cell = textField.superview?.superview as? AddDirectionTableViewCell {
            
            print(cell)
            
            if let indexPath = self.tableViewController.tableView.indexPathForCell(cell) {
                let currentRow = indexPath.row
                if var recipeDirections = self.tableViewController.recipeDirections["general"] {
                    if recipeDirections.count <= currentRow {
                        recipeDirections.append(directionText)
                    } else {
                        recipeDirections[currentRow] = directionText
                    }
                    
                    self.tableViewController.recipeDirections["general"] = recipeDirections

                    print(self.tableViewController.recipeDirections)

                }
            }
        }
    }

}
