//
//  GeneralInfoTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 21/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class GeneralInfoTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet var levelTextField: NoActionsTextField!
    @IBOutlet var typeTextField: NoActionsTextField!
    @IBOutlet var categoriesLabel: UILabel!
    
    var levelOptions = [getLocalizedString("levelBegginer"), getLocalizedString("levelIntermediate"), getLocalizedString("levelAdvanced")]
    var typeOptions = [getLocalizedString("Dairy"), getLocalizedString("Veggie"), getLocalizedString("Meat")]
    
    let levelPickerView = UIPickerView()
    let typePickerView = UIPickerView()
    
    var activeTextField: NoActionsTextField?
    var tableViewController: AddRecipeViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.createPickerForTextField(levelTextField, pickerView: levelPickerView)
        self.createPickerForTextField(typeTextField, pickerView: typePickerView)
        
        self.categoriesLabel.isUserInteractionEnabled = true
        self.categoriesLabelToSelectState()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GeneralInfoTableViewCell.showCategories))
        tapGesture.numberOfTapsRequired = 1
        self.categoriesLabel.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralInfoTableViewCell.doneSelectingCategories(_:)), name: NSNotification.Name(rawValue: AddRecipeViewController.NotificationDoneSelectingCategories), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GeneralInfoTableViewCell.uploadRecipeSuccess(_:)), name: NSNotification.Name(rawValue: AddRecipeViewController.NotificationUploadRecipeSuccess), object: nil)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    //--------------------------------------
    // MARK: - UIPickerViewDataSource methods
    //--------------------------------------

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePickerView {
            return typeOptions.count
        } else if pickerView == levelPickerView {
            return levelOptions.count
        }
        return 0
    }
    
    //--------------------------------------
    // MARK: - UIPickerViewDelegate methods
    //--------------------------------------

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePickerView {
            return typeOptions[row]
        } else if pickerView == levelPickerView {
            return levelOptions[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePickerView {
            let selectedType = typeOptions[row]
            typeTextField.text = selectedType
            self.tableViewController.recipeType = selectedType
        } else if pickerView == levelPickerView {
            let selectedLevel = levelOptions[row]
            levelTextField.text = selectedLevel
            self.tableViewController.recipeLevel = selectedLevel
        }
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func cancelPicker() {
        activeTextField?.resignFirstResponder()
    }
    
    func donePicker() {
        activeTextField?.resignFirstResponder()
        if activeTextField == self.levelTextField {
            self.tableViewController.recipeLevel = self.levelOptions[levelPickerView.selectedRow(inComponent: 0)]
        } else if activeTextField == self.typeTextField {
            self.tableViewController.recipeType = self.typeOptions[typePickerView.selectedRow(inComponent: 0)]
        }
    }
    
    func createPickerForTextField(_ textField: NoActionsTextField, pickerView: UIPickerView) {
        textField.delegate = self
        pickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = Helpers.sharedInstance.getRedColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(GeneralInfoTableViewCell.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(GeneralInfoTableViewCell.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    func categoriesLabelToSelectState() {
        self.categoriesLabel.textColor = Helpers.sharedInstance.uicolorFromHex(0xC4C4C8)
        self.categoriesLabel.text = getLocalizedString("clickToChoose")
    }
    
    //--------------------------------------
    // MARK: - actions
    //--------------------------------------

    func showCategories() {
        self.tableViewController.performSegue(withIdentifier: self.tableViewController.SegueSelectCategoriesTableViewController, sender: nil)
    }
    
    func doneSelectingCategories(_ notification: Notification) {
        if let selectedCategories = notification.object as? [Category] {

            var text = ""

            if selectedCategories.isEmpty {
                self.categoriesLabel.textColor = Helpers.sharedInstance.uicolorFromHex(0xC4C4C8)
                
                text = getLocalizedString("clickToChoose")
                
            } else {
                self.categoriesLabel.textColor = UIColor.black
        
                for (index, selectedCategory) in selectedCategories.enumerated() {
                    if index != 0 {
                        text += ", "
                    }
                    text += selectedCategory.name
                }
            }
            
            self.categoriesLabel.text = text

        }
    }
    
    func uploadRecipeSuccess(_ notification: Notification) {
        self.levelTextField.text = ""
        self.typeTextField.text = ""
        self.categoriesLabelToSelectState()
    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        activeTextField = textField as? NoActionsTextField
        if textField == typeTextField {
            typeTextField.text = self.typeOptions[self.typePickerView.selectedRow(inComponent: 0)]
        } else if textField == levelTextField {
            levelTextField.text = self.levelOptions[self.levelPickerView.selectedRow(inComponent: 0)]
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.donePicker()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
