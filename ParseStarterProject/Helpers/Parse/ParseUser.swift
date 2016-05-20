//
//  ParseUser.swift
//  Recipes
//
//  Created by Ori Dahan on 20/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseUser {
    
    var user: PFUser!
    
    init(user: PFUser) {
        self.user = user
    }
    
    //--------------------------------------
    // MARK: - Getters
    //--------------------------------------

    func getRole() -> String {
        if let role = self.user["role"] as? String {
            return role
        }
        return ""
    }
    
    //--------------------------------------
    // MARK: - Tests
    //--------------------------------------

    func isAdmin() -> Bool {
        return self.getRole() == "admin"
    }
}
