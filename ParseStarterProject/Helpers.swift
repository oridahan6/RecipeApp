//
//  Helpers.swift
//  Recipes
//
//  Created by Ori Dahan on 28/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Helpers {
    
    // MARK:- Images Methods
    func updateImageFromUrlAsync(url: String, imageViewToUpdate: UIImageView) {
        let imgURL = NSURL(string: url)!
        
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                if let data = data {
                    
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Store the image in to our cache
                    //                    self.imageCache[urlString] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
//                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? RecipeTableViewCell {
                            imageViewToUpdate.image = image
//                        }
                    })
                }
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
        })
 
    }
    
    func getDeviceSpecificBGImage(imageName: String) -> UIImage {
        var BGImage: UIImage = UIImage(named: "\(imageName).png")!
        
        let screenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
        let scale: CGFloat = UIScreen.mainScreen().scale
        
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
    func convertMinutesToHoursAndMinText(minutesToConvert: Int) -> String {
        let hours = minutesToConvert / (60);
        let minutes = minutesToConvert - hours * (60);
        
        if hours == 0 {
            return "\(minutes) " +  getLocalizedString("minutes")
        } else if minutes == 0 {
            if hours == 1 {
                return getLocalizedString("hour")
            } else if hours == 2 {
                return getLocalizedString("2hours")
            }
            return "\(hours) " +  getLocalizedString("hours")
        }
        
        return "\(hours)" + getLocalizedString("hoursShort") + "\(minutes)" + getLocalizedString("minutesShort")
    }
    
    func getFractionSymbolFromString(str: String) -> String {
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
    
    func getSingularOrPluralForm(number: Int, textToConvert: String) -> String {
        
        if number == 1 {
            return getLocalizedString(textToConvert + "Singular") + " " + getLocalizedString("singular")
        }
        return "\(number) " + getLocalizedString(textToConvert + "Plural")
    }
    
    //--------------------------------------
    // MARK: - Internet
    //--------------------------------------
    class func isInternetConnectionAvailable() -> Bool {
        if Reachability.isConnectedToNetwork() != true {
            return false
        }
        return true
    }
    
    //--------------------------------------
    // MARK: - Color
    //--------------------------------------

    class func getRedColor(alpha: CGFloat = 1.0) -> UIColor {
        var alphaValue = alpha
        if alpha > 1 || alpha < 0 {
            alphaValue = 1
        }
        return UIColor(red:0.69, green:0.29, blue:0.29, alpha:alphaValue)
    }
    
}

func getLocalizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
