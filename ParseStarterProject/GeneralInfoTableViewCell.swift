//
//  GeneralInfoTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 21/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class GeneralInfoTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet var levelTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    
    var levelOptions = [getLocalizedString("levelBegginer"), getLocalizedString("levelIntermediate"), getLocalizedString("levelAdvanced")]
    var typeOptions = [getLocalizedString("Dairy"), getLocalizedString("Veggie"), getLocalizedString("Meat")]
    
    let levelPickerView = UIPickerView()
    let typePickerView = UIPickerView()
    
    var activeTextField:UITextField?
    var tableViewController: AddRecipeViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.createPickerForTextField(levelTextField, pickerView: levelPickerView)
        self.createPickerForTextField(typeTextField, pickerView: typePickerView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
    }
    
    //--------------------------------------
    // MARK: - UIPickerViewDataSource methods
    //--------------------------------------

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePickerView {
            return typeOptions[row]
        } else if pickerView == levelPickerView {
            return levelOptions[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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

    func cancelPicker(sender: UIBarButtonItem) {
        activeTextField?.resignFirstResponder()
    }
    
    func donePicker(sender: UIBarButtonItem) {
        activeTextField?.resignFirstResponder()
    }
    
    func createPickerForTextField(textField: UITextField, pickerView: UIPickerView) {
        textField.delegate = self
        pickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = Helpers.getRedColor()
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(GeneralInfoTableViewCell.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(GeneralInfoTableViewCell.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) { // became first responder
        activeTextField = textField
        if textField == typeTextField {
            typeTextField.text = self.typeOptions[self.typePickerView.selectedRowInComponent(0)]
        } else if textField == levelTextField {
            levelTextField.text = self.levelOptions[self.levelPickerView.selectedRowInComponent(0)]
        }
    }

}
