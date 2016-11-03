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
    
    fileprivate init() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setRingThickness(4)
        SVProgressHUD.setBackgroundColor(Helpers.sharedInstance.getRedColor())
        SVProgressHUD.setForegroundColor(Helpers.sharedInstance.getNudeColor())
        SVProgressHUD.setFont(Helpers.sharedInstance.getTextFont(16))
    }
    
    func showLoadingHUD() {
        SVProgressHUD.show(withStatus: getLocalizedString("loading"))
    }
    
    func showPostingHUD() {
        SVProgressHUD.show(withStatus: getLocalizedString("submitting"))
    }
    
    func showLoginInHUD() {
        SVProgressHUD.show(withStatus: getLocalizedString("login-in"))
    }
    
    func dissmisHUD() {
        SVProgressHUD.dismiss()
    }
    
    
}
