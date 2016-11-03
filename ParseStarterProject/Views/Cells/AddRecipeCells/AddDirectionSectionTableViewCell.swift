//
//  AddDirectionSectionTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 01/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddDirectionSectionTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var directionSectionTextField: UITextField!
    
    var tableViewController: AddRecipeViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.directionSectionTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
