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
            return "\(minutes) " +  NSLocalizedString("minutes", comment: "")
        } else if minutes == 0 {
            if hours == 1 {
                return NSLocalizedString("hour", comment: "")
            } else if hours == 2 {
                return NSLocalizedString("2hours", comment: "")
            }
            return "\(hours) " +  NSLocalizedString("hours", comment: "")
        }
        
        return "\(hours)" + NSLocalizedString("hoursShort", comment: "") + "\(minutes)" + NSLocalizedString("minutesShort", comment: "")
    }
    
}