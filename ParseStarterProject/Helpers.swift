//
//  Helpers.swift
//  Recipes
//
//  Created by Ori Dahan on 28/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Helpers {
    
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
    
}

func getLocalizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
