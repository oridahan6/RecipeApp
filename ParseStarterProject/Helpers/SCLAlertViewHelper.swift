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
    
    private init() {}
    
    func showInfoAlert(alertTextType: String) {
        let alert = SCLAlertView(appearance: self.getAppearance())
        
        alert.addButton(getLocalizedString("OK")) {}
        alert.showInfo(self.getTitle(alertTextType), subTitle: self.getSubtitle(alertTextType))
    }
    
    func showSuccessAlert(alertTextType: String, action:() -> Void = {}) {
        let alert = SCLAlertView(appearance: self.getAppearance())
        
        alert.addButton(getLocalizedString("OK"), action: action)
        alert.showSuccess(self.getTitle(alertTextType), subTitle: self.getSubtitle(alertTextType))
    }
    
    func showErrorAlert(alertTextType: String) {
        let alert = SCLAlertView(appearance: self.getAppearance())
        
        alert.addButton(getLocalizedString("OK")) {}
        alert.showError(self.getTitle(alertTextType), subTitle: self.getSubtitle(alertTextType))
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    private func getAppearance() -> SCLAlertView.SCLAppearance {
        let apperance = SCLAlertView.SCLAppearance(
            kTitleFont: Helpers.sharedInstance.getTitleFont(24),
            kTitleHeight: 40,
            kTextFont: Helpers.sharedInstance.getTextFont(16),
            kTextHeight: 30,
            kButtonFont: Helpers.sharedInstance.getTextFont(16, bold: true),
            showCloseButton: false
        )
        return apperance
    }
    
    private func getTitle(alertTextType: String) -> String {
        return getLocalizedString(alertTextType + "Title")
    }
    
    private func getSubtitle(alertTextType: String) -> String {
        return getLocalizedString(alertTextType + "Message")
    }

}
