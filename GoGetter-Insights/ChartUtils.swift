//
//  ChartUtils.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/28/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import Charts

// this file has a Date extension and a few utilities to be used with Charts
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    var startOfLastWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: -7, to: sunday)
    }
    
    var endOfLastWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: -1, to: sunday)
    }
    
    var startOfThisMonth: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let startOfThisMonth = gregorian.date(from: gregorian.dateComponents([.year, .month], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: startOfThisMonth)
    }
    
    var endOfThisMonth: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let startOfThisMonth = gregorian.date(from: gregorian.dateComponents([.year, .month], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: -1, to: gregorian.date(byAdding: .month, value: 1, to: startOfThisMonth)!)
    }
    
    var startOfLastMonth: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let startOfThisMonth = gregorian.date(from: gregorian.dateComponents([.year, .month], from: self)) else { return nil }
        return gregorian.date(byAdding: .month, value: -1, to: startOfThisMonth)
    }
    
    var endOfLastMonth: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let startOfThisMonth = gregorian.date(from: gregorian.dateComponents([.year, .month], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: -1, to: startOfThisMonth)
    }
    
    var startOfThisYear: Date? {
        let year = Calendar.current.component(.year, from: Date())
        return Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))
    }
    
    var endOfThisYear: Date? {
        return Date()
    }
    
    var startOfLastYear: Date? {
        let year = Calendar.current.component(.year, from: Date())
        return Calendar.current.date(from: DateComponents(year: year - 1, month: 1, day: 1))
    }
    
    var endOfLastYear: Date? {
        let year = Calendar.current.component(.year, from: Date())
        return Calendar.current.date(from: DateComponents(year: year - 1, month: 12, day: 31))
    }
    
    func oneDayAgo() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(byAdding: .day, value: -1, to: self)!
    }
    
    func sevenDaysAgo() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(byAdding: .day, value: -7, to: self)!
    }
    
    func thirtyDaysAgo() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(byAdding: .day, value: -30, to: self)!
    }
    
    func oneDayAhead() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(byAdding: .day, value: 1, to: self)!
    }
    
    func sevenDaysAhead() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(byAdding: .day, value: 7, to: self)!
    }
    
    func thirtyDaysAhead() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(byAdding: .day, value: 30, to: self)!
    }
    
    func getStartingDate(fromMode: Int) -> Date {
        switch fromMode {
        case 0:
            return oneDayAgo()
        case 1:
            return sevenDaysAgo()
        case 2:
            return thirtyDaysAgo()
        default:
            return self
        }
    }
    
    func getEndingDate(fromMode: Int) -> Date {
        switch fromMode {
        case 0:
            return oneDayAhead()
        case 1:
            return sevenDaysAhead()
        case 2:
            return thirtyDaysAhead()
        default:
            return self
        }
    }
    
    func getThisWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let startweek = formatter.string(from:self.startOfWeek!)
        let endweek = formatter.string(from:self.endOfWeek!)
        return " " + startweek + "-\n" + endweek
    }
    
    func getMonthNo() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
}

class ChartUtils {
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    //Return day of week from date string
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    // True mod function
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
}
