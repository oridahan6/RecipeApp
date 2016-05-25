//
//  LoginViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 19/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextField: HoshiTextField!
    @IBOutlet var passwordTextField: HoshiTextField!
    @IBOutlet var buttonLabel: UILabel!
    
    @IBAction func login(sender: AnyObject) {
        
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
            if username == "" || password == "" {
                self.showErrorAlert(701)
            } else {
                ParseHelper.login(username, password: password, vc: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fix for view frame y set to navigation bar because we set the navbar translucent to false
        self.extendedLayoutIncludesOpaqueBars = true
        
        buttonLabel.text = getLocalizedString("enter")
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === usernameTextField) {
            passwordTextField.becomeFirstResponder()
        } else if (textField === passwordTextField) {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    //--------------------------------------
    // MARK: - Helper methods
    //--------------------------------------

    func beginUpdateView() {
        // if keyboard is shown - SVProgressHUD is aligned more to the top
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        SVProgressHUDHelper.sharedInstance.showLoginInHUD()
    }
    
    func endUpdateView() {
        SVProgressHUDHelper.sharedInstance.dissmisHUD()
    }

    func showSuccessAlert() {
        SCLAlertViewHelper.sharedInstance.showSuccessAlert("loginSuccess", action: { self.checkUserExistsAndReturnToAboutVC() })
    }

    func showErrorAlert(errorCode: Int) {
        var alertTextType = "generalError"
        switch errorCode {
        case 101:
            alertTextType = "wrongUsernamePassword"
        case 701:
            alertTextType = "emptyUsernamePassword"
        default:
            alertTextType = "generalError"
        }
        
        SCLAlertViewHelper.sharedInstance.showErrorAlert(alertTextType)
    }
    
    func checkUserExistsAndReturnToAboutVC() {
        if let user = ParseHelper.currentUser() {
            let parseUser = ParseUser(user: user)
            if parseUser.isAdmin() {
                if let navigationController = self.navigationController {
                    navigationController.popViewControllerAnimated(true)
                }
            }
        }
    }
}
