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
        
        NotificationCenter.default.addObserver(self, selector: #selector(SectionHeaderTitleTableViewCell.uploadRecipeSuccess(_:)), name: NSNotification.Name(rawValue: AddRecipeViewController.NotificationUploadRecipeSuccess), object: nil)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func saveTitle(_ title: String?) {
        if let title = title {
            self.tableViewController.recipeTitle = title
        }
    }
    
    func uploadRecipeSuccess(_ notification: Notification) {
        self.titleTextField.text = ""
    }

    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.saveTitle(textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.saveTitle(textField.text)
        return true
    }

}
