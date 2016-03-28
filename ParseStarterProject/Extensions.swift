//
//  Extensions.swift
//  Recipes
//
//  Created by Ori Dahan on 28/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
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
    func offsetFrom(date:NSDate) -> String {
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