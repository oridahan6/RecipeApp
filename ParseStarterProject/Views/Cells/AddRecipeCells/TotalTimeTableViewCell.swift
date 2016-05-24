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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TotalTimeTableViewCell.uploadRecipeSuccess(_:)), name: AddRecipeViewController.NotificationUploadRecipeSuccess, object: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
    
    func createPickerForTextField(textField: UITextField, pickerView: UIPickerView) {
        textField.delegate = self
        pickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = Helpers.sharedInstance.getRedColor()
        toolBar.sizeToFit()
        
        // Add fixed labels
        self.addFixedLabelsToPickerView(pickerView)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(GeneralInfoTableViewCell.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(GeneralInfoTableViewCell.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    func addFixedLabelsToPickerView(pickerView: UIPickerView) {
        let hourLabel = UILabel(frame: CGRectMake(200, 93, 40, 30))
        hourLabel.backgroundColor = UIColor.clearColor()
        hourLabel.text = getLocalizedString("hours")
        hourLabel.textAlignment = NSTextAlignment.Right
        hourLabel.textColor = UIColor.blackColor()
        hourLabel.font = Helpers.sharedInstance.getTextFont(16)
        
        pickerView.addSubview(hourLabel)
        
        let minLabel = UILabel(frame: CGRectMake(65, 93, 40, 30))
        minLabel.backgroundColor = UIColor.clearColor()
        minLabel.text = getLocalizedString("minutes")
        minLabel.textAlignment = NSTextAlignment.Right
        minLabel.textColor = UIColor.blackColor()
        minLabel.font = Helpers.sharedInstance.getTextFont(16)
        
        pickerView.addSubview(minLabel)
    }

    func getTimeFromPickerView(pickerView: UIPickerView) -> Int {
        let hours = hoursOptions[pickerView.selectedRowInComponent(1)]
        let minutes = minutesOptions[pickerView.selectedRowInComponent(0)]
        
        return 60*hours + minutes
    }
    
    func getTimeFromHoursSelection(pickerView: UIPickerView, selectedRow: Int) -> Int {
        let hours = hoursOptions[selectedRow]
        let minutes = minutesOptions[pickerView.selectedRowInComponent(0)]

        return 60*hours + minutes
    }
    
    func getTimeFromMinutesSelection(pickerView: UIPickerView, selectedRow: Int) -> Int {
        let hours = hoursOptions[pickerView.selectedRowInComponent(1)]
        let minutes = minutesOptions[selectedRow]

        return 60*hours + minutes
    }
    
    func getTextFromHoursSelection(pickerView: UIPickerView, selectedRow: Int) -> String {
        let hours = hoursOptions[selectedRow]
        let minutes = minutesOptions[pickerView.selectedRowInComponent(0)]
        return self.getTextFromHoursAndMinutes(hours, minutes: minutes)
    }

    func getTextFromMinutesSelection(pickerView: UIPickerView, selectedRow: Int) -> String {
        let hours = hoursOptions[pickerView.selectedRowInComponent(1)]
        let minutes = minutesOptions[selectedRow]
        return self.getTextFromHoursAndMinutes(hours, minutes: minutes)
    }
    
    func getTextFromHoursAndMinutes(hours: Int, minutes: Int) -> String {
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

    func uploadRecipeSuccess(notification: NSNotification) {
        self.prepTimeTextField.text = ""
        self.cookTimeTextField.text = ""
    }

    //--------------------------------------
    // MARK: - UIPickerViewDataSource methods
    //--------------------------------------
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return minutesOptions.count
        case 1:
            return hoursOptions.count
        default:
            return 0
        }

    }
  
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
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
        let label = UILabel(frame: CGRectMake(0, 0, 40, 30))
        label.backgroundColor = UIColor.clearColor()
        label.text = text
        label.textAlignment = NSTextAlignment.Right
        label.textColor = UIColor.blackColor()
        label.font = Helpers.sharedInstance.getTextFont(24)
        return label
    }
 
    //--------------------------------------
    // MARK: - UIPickerViewDelegate methods
    //--------------------------------------
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 130
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField as? NoActionsTextField
        
        if textField == prepTimeTextField {
            activePickerView = self.prepTimePickerView
            self.prepTimePickerView.selectRow(15, inComponent: 0, animated: true)
            self.prepTimeTextField.text = getTextFromHoursAndMinutes(self.prepTimePickerView.selectedRowInComponent(1), minutes: self.prepTimePickerView.selectedRowInComponent(0))
        } else if textField == cookTimeTextField {
            activePickerView = self.cookTimePickerView
            self.cookTimePickerView.selectRow(15, inComponent: 0, animated: true)
            self.cookTimeTextField.text = getTextFromHoursAndMinutes(self.cookTimePickerView.selectedRowInComponent(1), minutes: self.cookTimePickerView.selectedRowInComponent(0))
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.donePicker()
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }

}
