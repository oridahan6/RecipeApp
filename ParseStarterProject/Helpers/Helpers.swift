//
//  Helpers.swift
//  Recipes
//
//  Created by Ori Dahan on 28/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Helpers {
    
    static let sharedInstance = Helpers()
    
    fileprivate init() {}

    // MARK:- Images Methods    
    func getDeviceSpecificBGImage(_ imageName: String) -> UIImage {
        var BGImage: UIImage = UIImage(named: "\(imageName).png")!
        
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        let scale: CGFloat = UIScreen.main.scale
        
        if scale == 2.0 && screenHeight == 568.0 {
            BGImage = UIImage(named: "\(imageName)-568h@2x.png")!
        } else if scale == 2.0 && screenHeight == 667.0 {
            BGImage = UIImage(named: "\(imageName)-667h@2x.png")!
        } else if scale == 3.0 && screenHeight == 736.0 {
            BGImage = UIImage(named: "\(imageName)-736h@3x.png")!
        } else if scale == 2.0 {
            BGImage = UIImage(named: "\(imageName)@2x.png")!
        }
        
        return BGImage
    }
    
    // MARK:- Numbers Methods
    func convertMinutesToHoursAndMinText(_ minutesToConvert: Int) -> String {
        let hours = minutesToConvert / (60);
        let minutes = minutesToConvert - hours * (60);
        
        var text = ""
        
        if hours == 1 {
            text += getLocalizedString("hour")
        } else if hours == 2 {
            text += getLocalizedString("2hours")
        } else if hours > 0 {
            text += "\(hours) " +  getLocalizedString("hours")
        }
        
        if hours > 0 && minutes > 0 {
            if minutes == 30 {
                text += " " + getLocalizedString("and")
            } else {
                text += " " + getLocalizedString("and") + "- "
            }
        }
        
        if minutes > 0 {
            if minutes == 30 {
                text += getLocalizedString("half")
            } else {
                text += "\(minutes) " + getLocalizedString("minutes")
            }
        }
        
        if hours == 0 && minutes == 30 {
            text += " " + getLocalizedString("hour")
        }
        
        return text

    }
    
    func getFractionSymbolFromString(_ str: String) -> String {
        if str == "1/2" {
            return "½"
        } else if str == "1/4" {
            return "¼"
        } else if str == "3/4" {
            return "¾"
        } else if str == "1/3" {
            return "⅓"
        } else if str == "2/3" {
            return "⅔"
        }
        return str
    }
    
    func getSingularOrPluralForm(_ number: Int, textToConvert: String) -> String {
        
        if number == 1 {
            return getLocalizedString(textToConvert + "Singular") + " " + getLocalizedString("singular")
        }
        return "\(number) " + getLocalizedString(textToConvert + "Plural")
    }
    
    //--------------------------------------
    // MARK: - Text
    //--------------------------------------

    func getTitleFont(_ size: CGFloat = 26) -> UIFont {
        if let font = UIFont(name: "Hillel CLM", size: size) {
            return font
        }
        return UIFont()
    }
    
    func getTextFont(_ size: CGFloat = 14, bold: Bool = false) -> UIFont {
        if let font = UIFont(name: "Alef-" + (bold ? "bold" : "Regular"), size: size) {
            return font
        }
        return UIFont()
    }
    
    //--------------------------------------
    // MARK: - Strings
    //--------------------------------------

    func randomStringWithLength (_ len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return String(randomString)
    }
    
    //--------------------------------------
    // MARK: - Internet
    //--------------------------------------
    
    func isInternetConnectionAvailable() -> Bool {
        if Reachability.isConnectedToNetwork() != true {
            return false
        }
        return true
    }
    
    //--------------------------------------
    // MARK: - Color
    //--------------------------------------

    func uicolorFromHex(_ rgbValue:UInt32, alpha: CGFloat = 1.0) -> UIColor {
        
        var alphaValue = alpha
        if alpha > 1 || alpha < 0 {
            alphaValue = 1
        }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:alphaValue)
    }
    
    func getRedColor(_ alpha: CGFloat = 1.0) -> UIColor {
        return self.uicolorFromHex(0xA73535, alpha: alpha)
    }
    
    func getYellowColor(_ alpha: CGFloat = 1.0) -> UIColor {
        return self.uicolorFromHex(0xf3b45f, alpha: alpha)
    }
    
    func getGreenColor(_ alpha: CGFloat = 1.0) -> UIColor {
        return self.uicolorFromHex(0x55AA6D, alpha: alpha)
    }
    
    func getNudeColor(_ alpha: CGFloat = 1.0) -> UIColor {
        return self.uicolorFromHex(0xF2F0EA, alpha: alpha)
    }
    
    //--------------------------------------
    // MARK: - Hacks
    //--------------------------------------

    func hackForPlacingHUD(_ HUD: UIView) {
        let frame = HUD.frame
        HUD.frame = CGRect(x: frame.origin.x, y: frame.origin.y - 60, width: frame.size.width, height: frame.size.height)
    }

}

func getLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
