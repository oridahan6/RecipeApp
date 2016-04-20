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
        print("click")
        
        print(self.usernameTextField.text)
        print(self.passwordTextField.text)
        
        // handle empty values
        
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
            ParseHelper.login(username, password: password)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
