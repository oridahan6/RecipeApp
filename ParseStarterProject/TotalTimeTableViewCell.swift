//
//  TotalTimeTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 27/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class TotalTimeTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet var prepTimeTextField: UITextField!
    @IBOutlet var cookTimeTextField: UITextField!

    var hoursOptions = Array(0...24)
    var minutesOptions = Array(0...59)
    
    let prepTimePickerView = UIPickerView()
    let cookTimePickerView = UIPickerView()

    var activeTextField:UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.createPickerForTextField(prepTimeTextField, pickerView: prepTimePickerView)
        self.createPickerForTextField(cookTimeTextField, pickerView: cookTimePickerView)
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
        hourLabel.font = UIFont(name: "Alef-Regular", size: 16)
        
        pickerView.addSubview(hourLabel)
        
        let minLabel = UILabel(frame: CGRectMake(65, 93, 40, 30))
        minLabel.backgroundColor = UIColor.clearColor()
        minLabel.text = getLocalizedString("minutes")
        minLabel.textAlignment = NSTextAlignment.Right
        minLabel.textColor = UIColor.blackColor()
        minLabel.font = UIFont(name: "Alef-Regular", size: 16)
        
        pickerView.addSubview(minLabel)
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
        return text
        
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
        label.font = UIFont(name: "Alef-Regular", size: 24)
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
        } else if pickerView == cookTimePickerView {
            currentTextField = cookTimeTextField
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
        activeTextField = textField
        
        if textField == prepTimeTextField {
            self.prepTimePickerView.selectRow(15, inComponent: 0, animated: true)
            self.prepTimeTextField.text = getTextFromHoursAndMinutes(self.prepTimePickerView.selectedRowInComponent(1), minutes: self.prepTimePickerView.selectedRowInComponent(0))
        } else if textField == cookTimeTextField {
            self.cookTimePickerView.selectRow(15, inComponent: 0, animated: true)
            self.cookTimeTextField.text = getTextFromHoursAndMinutes(self.cookTimePickerView.selectedRowInComponent(1), minutes: self.cookTimePickerView.selectedRowInComponent(0))
        }
    }

}
