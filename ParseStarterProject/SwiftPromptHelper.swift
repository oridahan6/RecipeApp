//
//  SwiftPromptHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 11/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SwiftPromptHelper {
    
    class func getSwiftPromptView(frame: CGRect) -> SwiftPromptsView {
        return SwiftPromptsView(frame: self.getPromptFrame(frame))
    }
    
    class func buildErrorAlert(prompt: SwiftPromptsView, type: String) {
        self.buildAlert(prompt, color: Helpers.getRedColor(), type: type)
    }
    
    class func buildSuccessAlert(prompt: SwiftPromptsView, type: String) {
        self.buildAlert(prompt, color: Helpers.getGreenColor(), type: type)
    }
    
    class func buildAlert(prompt: SwiftPromptsView, color: UIColor, type: String) {
//        let transparencyColor = color.colorWithAlphaComponent(0.9)
        
        //Set the properties for the background
        prompt.setBlurringLevel(5.0)
        prompt.setColorWithTransparency(Helpers.getNudeColor(0.9))
        
        //Set the properties of the prompt
        prompt.setPromptHeader(getLocalizedString(type + "Title"))
        prompt.setPromptContentText(getLocalizedString(type + "Message"))
        prompt.setPromptTopLineVisibility(true)
        prompt.setPromptBottomLineVisibility(false)
        prompt.setPromptBottomBarVisibility(true)
        prompt.setPromptDismissIconVisibility(false)
        prompt.setPromptOutlineVisibility(true)
        prompt.setPromptHeaderTxtColor(color)
        prompt.setPromptOutlineColor(color)
        //        prompt.setPromptDismissIconColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setPromptContentTxtColor(UIColor.blackColor())
        prompt.setPromptTopLineColor(color)
        prompt.setPromptBackgroundColor(Helpers.getNudeColor(0.67))
        prompt.setPromptBottomBarColor(color)
        prompt.setMainButtonColor(Helpers.getNudeColor())
        prompt.setMainButtonText(getLocalizedString("OK"))

    }
    
    class func getPromptFrame(frame: CGRect) -> CGRect {
        var retFrame = frame
        retFrame.size.height = frame.height - self.getPromptHalfHeight()
        return retFrame
    }

    class func getPromptHalfHeight() -> CGFloat {
        return 98.5
    }
    
}
