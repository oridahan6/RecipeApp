//
//  NoActionsTextField.swift
//  Recipes
//
//  Created by Ori Dahan on 18/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class NoActionsTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tintColor = UIColor.clearColor()
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        /*
        if  action == #selector(NSObject.copy(_:)) ||
            action == #selector(NSObject.select(_:)) ||
            action == #selector(NSObject.selectAll(_:)) ||
            action == #selector(NSObject.paste(_:)) ||
            action == #selector(NSObject.delete(_:)) ||
            action == #selector(NSObject.cut(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
        */
        return false
    }

}
