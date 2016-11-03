//
//  SCLAlertViewHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 25/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SCLAlertViewHelper {
    
    static let sharedInstance = SCLAlertViewHelper()
    
    fileprivate init() {}
    
    func showInfoAlert(_ alertTextType: String) {
        let alert = SCLAlertView(appearance: self.getAppearance())
        
        alert.addButton(getLocalizedString("OK")) {}
        alert.showInfo(self.getTitle(alertTextType), subTitle: self.getSubtitle(alertTextType))
    }
    
    func showSuccessAlert(_ alertTextType: String, action:@escaping () -> Void = {}) {
        let alert = SCLAlertView(appearance: self.getAppearance())
        
        alert.addButton(getLocalizedString("OK"), action: action)
        alert.showSuccess(self.getTitle(alertTextType), subTitle: self.getSubtitle(alertTextType))
    }
    
    func showErrorAlert(_ alertTextType: String) {
        let alert = SCLAlertView(appearance: self.getAppearance())
        
        alert.addButton(getLocalizedString("OK")) {}
        alert.showError(self.getTitle(alertTextType), subTitle: self.getSubtitle(alertTextType))
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    fileprivate func getAppearance() -> SCLAlertView.SCLAppearance {
        let apperance = SCLAlertView.SCLAppearance(
            kTitleFont: Helpers.sharedInstance.getTitleFont(24),
            kTextFont: Helpers.sharedInstance.getTextFont(16),
            kButtonFont: Helpers.sharedInstance.getTextFont(16, bold: true),
            // passing kTitleHeight, kTextHeight not working for some reason
//            kTitleHeight: CGFloat(40),
//            kTextHeight: 30,
            showCloseButton: false
        )
        return apperance
    }
    
    fileprivate func getTitle(_ alertTextType: String) -> String {
        return getLocalizedString(alertTextType + "Title")
    }
    
    fileprivate func getSubtitle(_ alertTextType: String) -> String {
        return getLocalizedString(alertTextType + "Message")
    }

}
