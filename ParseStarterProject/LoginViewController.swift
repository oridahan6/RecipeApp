//
//  LoginViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 19/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, SwiftPromptsProtocol {

    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!

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
        
        // Activity Indicator
        self.activityIndicator = ActivityIndicator(largeActivityView: self.view, options: ["isShowLabel": false])
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

    func showSuccessAlert() {
        //Create an instance of SwiftPromptsView and assign its delegate
        prompt = SwiftPromptsView(frame: self.view.frame)
        prompt.delegate = self
        
        SwiftPromptHelper.buildSuccessAlert(prompt, type: "loginSuccess")
        self.view.addSubview(prompt)
    }

    func showErrorAlert(errorCode: Int) {
        var propmptType = "generalError"
        switch errorCode {
        case 101:
            propmptType = "wrongUsernamePassword"
        case 701:
            propmptType = "emptyUsernamePassword"
        default:
            propmptType = "generalError"
        }
        
        //Create an instance of SwiftPromptsView and assign its delegate
        prompt = SwiftPromptsView(frame: self.view.frame)
        prompt.delegate = self
        
        SwiftPromptHelper.buildErrorAlert(prompt, type: propmptType)
        self.view.addSubview(prompt)
    }
    
    //--------------------------------------
    // MARK: - SwiftPromptsProtocol delegate methods
    //--------------------------------------
    
    func clickedOnTheMainButton() {
        prompt.dismissPrompt()
        if let user = ParseHelper.currentUser() {
            let parseUser = ParseUser(user: user)
            if parseUser.isAdmin() {
                if let navigationController = self.navigationController {
                    navigationController.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    func clickedOnTheSecondButton() {
        prompt.dismissPrompt()
    }
    
    func promptWasDismissed() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
