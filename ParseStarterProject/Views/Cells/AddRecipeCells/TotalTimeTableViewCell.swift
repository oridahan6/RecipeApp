//
//  TotalTimeTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 27/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class TotalTimeTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet var prepTimeTextField: NoActionsTextField!
    @IBOutlet var cookTimeTextField: NoActionsTextField!

    var hoursOptions = Array(0...24)
    var minutesOptions = Array(0...59)
    
    let prepTimePickerView = UIPickerView()
    let cookTimePickerView = UIPickerView()

    var activeTextField: NoActionsTextField?
    var activePickerView: UIPickerView?
    var tableViewController: AddRecipeViewController!

    var currentPrepTime = 0
    var currentCookTime = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.createPickerForTextField(prepTimeTextField, pickerView: prepTimePickerView)
        self.createPickerForTextField(cookTimeTextField, pickerView: cookTimePickerView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TotalTimeTableViewCell.uploadRecipeSuccess(_:)), name: NSNotification.Name(rawValue: AddRecipeViewController.NotificationUploadRecipeSuccess), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------
    
    func cancelPicker() {
        activeTextField?.resignFirstResponder()
        var hours = 0
        var minutes = 0
        if activePickerView == prepTimePickerView {
            hours = self.currentPrepTime / 60
            minutes = self.currentPrepTime - hours * (60)
            self.tableViewController.recipePrepTime = self.currentPrepTime
        } else {
            hours = self.currentCookTime / 60
            minutes = self.currentCookTime - hours * (60)
            self.tableViewController.recipeCookTime = self.currentCookTime
        }
        activeTextField?.text = self.getTextFromHoursAndMinutes(hours, minutes: minutes)
    }
    
    func donePicker() {
        activeTextField?.resignFirstResponder()
        if let pickerView = self.activePickerView {
            let time = self.getTimeFromPickerView(pickerView)
            if activePickerView == prepTimePickerView {
                self.tableViewController.recipePrepTime = time
                self.currentPrepTime = time
            } else {
                self.tableViewController.recipeCookTime = time
                self.currentCookTime = time
            }
        }
    }
    
    func createPickerForTextField(_ textField: UITextField, pickerView: UIPickerView) {
        textField.delegate = self
        pickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = Helpers.sharedInstance.getRedColor()
        toolBar.sizeToFit()
        
        // Add fixed labels
        self.addFixedLabelsToPickerView(pickerView)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(GeneralInfoTableViewCell.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(GeneralInfoTableViewCell.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    func addFixedLabelsToPickerView(_ pickerView: UIPickerView) {
        let hourLabel = UILabel(frame: CGRect(x: 200, y: 93, width: 40, height: 30))
        hourLabel.backgroundColor = UIColor.clear
        hourLabel.text = getLocalizedString("hours")
        hourLabel.textAlignment = NSTextAlignment.right
        hourLabel.textColor = UIColor.black
        hourLabel.font = Helpers.sharedInstance.getTextFont(16)
        
        pickerView.addSubview(hourLabel)
        
        let minLabel = UILabel(frame: CGRect(x: 65, y: 93, width: 40, height: 30))
        minLabel.backgroundColor = UIColor.clear
        minLabel.text = getLocalizedString("minutes")
        minLabel.textAlignment = NSTextAlignment.right
        minLabel.textColor = UIColor.black
        minLabel.font = Helpers.sharedInstance.getTextFont(16)
        
        pickerView.addSubview(minLabel)
    }

    func getTimeFromPickerView(_ pickerView: UIPickerView) -> Int {
        let hours = hoursOptions[pickerView.selectedRow(inComponent: 1)]
        let minutes = minutesOptions[pickerView.selectedRow(inComponent: 0)]
        
        return 60*hours + minutes
    }
    
    func getTimeFromHoursSelection(_ pickerView: UIPickerView, selectedRow: Int) -> Int {
        let hours = hoursOptions[selectedRow]
        let minutes = minutesOptions[pickerView.selectedRow(inComponent: 0)]

        return 60*hours + minutes
    }
    
    func getTimeFromMinutesSelection(_ pickerView: UIPickerView, selectedRow: Int) -> Int {
        let hours = hoursOptions[pickerView.selectedRow(inComponent: 1)]
        let minutes = minutesOptions[selectedRow]

        return 60*hours + minutes
    }
    
    func getTextFromHoursSelection(_ pickerView: UIPickerView, selectedRow: Int) -> String {
        let hours = hoursOptions[selectedRow]
        let minutes = minutesOptions[pickerView.selectedRow(inComponent: 0)]
        return self.getTextFromHoursAndMinutes(hours, minutes: minutes)
    }

    func getTextFromMinutesSelection(_ pickerView: UIPickerView, selectedRow: Int) -> String {
        let hours = hoursOptions[pickerView.selectedRow(inComponent: 1)]
        let minutes = minutesOptions[selectedRow]
        return self.getTextFromHoursAndMinutes(hours, minutes: minutes)
    }
    
    func getTextFromHoursAndMinutes(_ hours: Int, minutes: Int) -> String {
        var text = ""
        if hours > 0 {
            text += getLocalizedString("hours") + ": \(hours)"
        }
        if hours > 0 && minutes > 0{
            text += ", "
        }
        if minutes > 0 {
            text += getLocalizedString("minutes") + ": \(minutes)"
        }
        if hours == 0 && minutes == 0 {
            text = getLocalizedString("noTimeSelected")
        }
        return text
        
    }

    func uploadRecipeSuccess(_ notification: Notification) {
        self.prepTimeTextField.text = ""
        self.cookTimeTextField.text = ""
    }

    //--------------------------------------
    // MARK: - UIPickerViewDataSource methods
    //--------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return minutesOptions.count
        case 1:
            return hoursOptions.count
        default:
            return 0
        }

    }
  
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var text = ""
        
        switch component {
        case 0:
            text = String(minutesOptions[row])
        case 1:
            text = String(hoursOptions[row])
        default:
            return UIView()
        }
        
        if let label = view as? UILabel {
            return label
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        label.backgroundColor = UIColor.clear
        label.text = text
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.black
        label.font = Helpers.sharedInstance.getTextFont(24)
        return label
    }
 
    //--------------------------------------
    // MARK: - UIPickerViewDelegate methods
    //--------------------------------------
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 130
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var currentTextField: UITextField!
        if pickerView == prepTimePickerView {
            currentTextField = prepTimeTextField
            if component == 0 {
                self.tableViewController.recipePrepTime = self.getTimeFromMinutesSelection(pickerView, selectedRow: row)
            } else {
                self.tableViewController.recipePrepTime = self.getTimeFromHoursSelection(pickerView, selectedRow: row)
            }

        } else if pickerView == cookTimePickerView {
            currentTextField = cookTimeTextField
            if component == 0 {
                self.tableViewController.recipeCookTime = self.getTimeFromMinutesSelection(pickerView, selectedRow: row)
            } else {
                self.tableViewController.recipeCookTime = self.getTimeFromHoursSelection(pickerView, selectedRow: row)
            }
        }
        
        if component == 0 {
            currentTextField.text = self.getTextFromMinutesSelection(pickerView, selectedRow: row)
        } else {
            currentTextField.text = self.getTextFromHoursSelection(pickerView, selectedRow: row)
        }

    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField as? NoActionsTextField
        
        if textField == prepTimeTextField {
            activePickerView = self.prepTimePickerView
            self.prepTimePickerView.selectRow(15, inComponent: 0, animated: true)
            self.prepTimeTextField.text = getTextFromHoursAndMinutes(self.prepTimePickerView.selectedRow(inComponent: 1), minutes: self.prepTimePickerView.selectedRow(inComponent: 0))
        } else if textField == cookTimeTextField {
            activePickerView = self.cookTimePickerView
            self.cookTimePickerView.selectRow(15, inComponent: 0, animated: true)
            self.cookTimeTextField.text = getTextFromHoursAndMinutes(self.cookTimePickerView.selectedRow(inComponent: 1), minutes: self.cookTimePickerView.selectedRow(inComponent: 0))
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.donePicker()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

}
