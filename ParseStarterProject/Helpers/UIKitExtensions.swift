//
//  UIKitExtensions.swift
//  Recipes
//
//  Created by Ori Dahan on 19/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


// UIImage
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

//// UITextField
extension UITextField {
    func addBottomBorder() {
        let width = CGFloat(2.0)
        let borderColor = UIColor.darkGrayColor().CGColor
        
        let border = CALayer()
        border.borderColor = borderColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

// CALayer
// Add border to element
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, self.bounds.width, thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }
        
        border.backgroundColor = color.CGColor;
        
        self.addSublayer(border)
    }
    
}

// String
extension String {
    func matchesForRegexInText(regex: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            let results = regex.matchesInString(self,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func firstRegexMatches(regex: String) -> String {
        let matches = self.regexMatches(regex)
        if matches.isEmpty {
            return ""
        }
        return matches[0]
    }
    
    func regexMatches(pattern: String) -> Array<String> {
        let re: NSRegularExpression
        do {
            re = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return []
        }
        
        let matches = re.matchesInString(self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        var collectMatches: Array<String> = []
        for match in matches {
            // range at index 0: full match
            // range at index 1: first capture group
            let substring = (self as NSString).substringWithRange(match.rangeAtIndex(1))
            collectMatches.append(substring)
        }
        return collectMatches
    }
}

// operators
infix operator =~ {}
func =~(string:String, regex:String) -> Bool {
    return string.rangeOfString(regex, options: .RegularExpressionSearch) != nil
}

infix operator !=~ {}
func !=~(string:String, regex:String) -> Bool {
    return string.rangeOfString(regex, options: .RegularExpressionSearch) == nil
}
