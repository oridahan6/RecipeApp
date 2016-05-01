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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.directionSectionTextField.delegate = self
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

}
