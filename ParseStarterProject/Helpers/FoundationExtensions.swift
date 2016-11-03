//
//  Extensions.swift
//  Recipes
//
//  Created by Ori Dahan on 28/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

extension Date {
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
//    func offsetFrom(date:NSDate) -> String {
//        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
//        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
//        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
//        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
//        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
//        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
//        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
//        return ""
//    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 {
            if yearsFrom(date) == 1 {
                return getLocalizedString("year")
            }
            if yearsFrom(date) == 2 {
                return getLocalizedString("2years")
            }
            return "\(yearsFrom(date)) " + getLocalizedString("years")
        }
        if monthsFrom(date)  > 0 {
            if monthsFrom(date) == 1 {
                return getLocalizedString("month")
            }
            if monthsFrom(date) == 2 {
                return getLocalizedString("2months")
            }
            return "\(monthsFrom(date)) " + getLocalizedString("months")
        }
        if weeksFrom(date)   > 0 {
            if weeksFrom(date) == 1 {
                return getLocalizedString("week")
            }
            if weeksFrom(date) == 2 {
                return getLocalizedString("2weeks")
            }
            return "\(weeksFrom(date)) " + getLocalizedString("weeks")
        }
        if daysFrom(date)    > 0 {
            if daysFrom(date) == 1 {
                return getLocalizedString("day")
            }
            if daysFrom(date) == 2 {
                return getLocalizedString("2days")
            }
            return "\(daysFrom(date)) " + getLocalizedString("days")
        }
        if hoursFrom(date)   > 0 {
            if hoursFrom(date) == 1 {
                return getLocalizedString("hour")
            }
            if hoursFrom(date) == 2 {
                return getLocalizedString("2hours")
            }
            return "\(hoursFrom(date)) " + getLocalizedString("hours")
        }
        if minutesFrom(date) > 0 {
            if minutesFrom(date) == 1 {
                return getLocalizedString("minute")
            }
            return "\(minutesFrom(date)) " + getLocalizedString("minutes")
        }
        if secondsFrom(date) > 0 {
            if secondsFrom(date) == 1 {
                return getLocalizedString("second")
            }
            return "\(secondsFrom(date)) " + getLocalizedString("seconds")
        }
        return ""
    }

}

// Arrays
extension Collection where Iterator.Element : Comparable {

    // Return difference between arrays
    func getDiffFromArray(_ elem: [String]) -> [String] {
        if let selfArray = self as? [String] {
            let setA = Set(selfArray)
            let setB = Set(elem)
            
            // Return a set with all values in A which are not contained in B
            let diff = setA.subtracting(setB)
            
            return Array(diff)
        }
        return []
 
    }
}

extension RangeReplaceableCollection where Iterator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
}

extension NSRange {
    func rangeForString(_ str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        return str.characters.index(str.startIndex, offsetBy: location) ..< str.characters.index(str.startIndex, offsetBy: location + length)
    }
}
