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
    
    class func buildErrorAlert(prompt: SwiftPromptsView) {
        //Set the properties for the background
        prompt.setBlurringLevel(5.0)
        prompt.setColorWithTransparency(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.9))
        
        //Set the properties of the prompt
        prompt.setPromptHeader(getLocalizedString("noInternetConnectionTitle"))
        prompt.setPromptContentText(getLocalizedString("noInternetConnectionMessage"))
        prompt.setPromptTopLineVisibility(true)
        prompt.setPromptBottomLineVisibility(false)
        prompt.setPromptBottomBarVisibility(true)
        prompt.setPromptDismissIconVisibility(false)
        prompt.setPromptOutlineVisibility(true)
        prompt.setPromptHeaderTxtColor(Helpers.getRedColor())
        prompt.setPromptOutlineColor(Helpers.getRedColor())
        //        prompt.setPromptDismissIconColor(UIColor(red: 133.0/255.0, green: 133.0/255.0, blue: 133.0/255.0, alpha: 1.0))
        prompt.setPromptTopLineColor(Helpers.getRedColor())
        prompt.setPromptBackgroundColor(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.67))
        prompt.setPromptBottomBarColor(Helpers.getRedColor())
        prompt.setMainButtonColor(UIColor.whiteColor())
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
