//
//  SectionHeaderTitleTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 20/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SectionHeaderTitleTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var titleTextField: UITextField!
    
    var tableViewController: AddRecipeViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleTextField.delegate = self
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if let text = textField.text {
            self.tableViewController.recipeTitle = text
        }
        
        textField.resignFirstResponder()
        return true
    }

}
