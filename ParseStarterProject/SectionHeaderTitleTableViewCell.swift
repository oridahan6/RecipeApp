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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SectionHeaderTitleTableViewCell.uploadRecipeSuccess(_:)), name: AddRecipeViewController.NotificationUploadRecipeSuccess, object: nil)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func saveTitle(title: String?) {
        if let title = title {
            self.tableViewController.recipeTitle = title
        }
    }
    
    func uploadRecipeSuccess(notification: NSNotification) {
        self.titleTextField.text = ""
    }

    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.saveTitle(textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        self.saveTitle(textField.text)
        return true
    }

}
