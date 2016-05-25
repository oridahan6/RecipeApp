//
//  SVProgressHUDHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 24/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import SVProgressHUD

class SVProgressHUDHelper {
    
    static let sharedInstance = SVProgressHUDHelper()
    
    private init() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
        SVProgressHUD.setRingThickness(4)
        SVProgressHUD.setBackgroundColor(Helpers.sharedInstance.getRedColor())
        SVProgressHUD.setForegroundColor(Helpers.sharedInstance.getNudeColor())
        SVProgressHUD.setFont(Helpers.sharedInstance.getTextFont(16))
    }
    
    func showLoadingHUD() {
        SVProgressHUD.showWithStatus(getLocalizedString("loading"))
    }
    
    func showPostingHUD() {
        SVProgressHUD.showWithStatus(getLocalizedString("submitting"))
    }
    
    func showLoginInHUD() {
        SVProgressHUD.showWithStatus(getLocalizedString("login-in"))
    }
    
    func dissmisHUD() {
        SVProgressHUD.dismiss()
    }
    
    
}
