//
//  DateFormatter.swift
//  Calendar
//
//  Created by Zyme on 16/11/1.
//  Copyright © 2016年 Zyme. All rights reserved.
//

import Foundation

private let _zymeformatter = DateFormatter()

extension Date {
    
    var calendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    var year: Int {
        return dateUnit(component: .year)
    }
    var month: Int {
        return dateUnit(component: .month)
    }
    var day: Int {
        return dateUnit(component: .day)
    }

    var hour: Int {
        return dateUnit(component: .hour)
    }

    var minute: Int {
        return dateUnit(component: .minute)
    }

    var second: Int {
        return dateUnit(component: .second)
    }

    var weekday: Int {
        return dateUnit(component: .weekday)
    }
    
    func dateUnit(component: Calendar.Component)->Int {
        return self.calendar.component(component, from: self)
    }
    
    var weekdaybyStr: String {
        var tempStr = ""
        
        switch self.weekday {
        case 1:
            tempStr = "星期天"
        case 2:
            tempStr = "星期一"
        case 3:
            tempStr = "星期二"
        case 4:
            tempStr = "星期三"
        case 5:
            tempStr = "星期四"
        case 6:
            tempStr = "星期五"
        case 7:
            tempStr = "星期六"
     
        default:
            break
        }
        return tempStr
    }

    /// "yyyy-MM"
    var stringWithyyyyMMByLine: String {
        return stringWithDateFormat("yyyy-MM")
    }
    
    /// MM-dd
    var stringWithmmddByLine: String {
        return stringWithDateFormat("MM-dd")
    }
    
    /// MM月dd日
    var stringWithmmddByChinese: String{
        return stringWithDateFormat("MM月dd日")
    }
    
    ///HH:mm:ss
    var stringWithHHmmss: String{
       return stringWithDateFormat("HH:mm:ss")
    }
    
    /// yyyy-MM-dd
    var stringWithyyyyMMddByLine: String{
        return stringWithDateFormat("yyyy-MM-dd")
    }
    
    /// yyyy-MM-dd-HH:mm:ss
    var stringWithyyyyMMddHHmmssByLine: String {
        return stringWithDateFormat("yyyy-MM-dd-HH:mm:ss")
    }
    
    ///这个月有多少天
    var numberOfDaysInCurrentMonth: Int {
        // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
        let range = calendar.range(of: .day, in: .month, for: self)
        return (range?.count)!
    }
    
    /// 这个月的第一天是星期几 1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    var firstDayWeekofCurrentMonth: Int{
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1 //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        let firstDayOfMonthDate = calendar.date(from: components)
        let firstWeekday = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekday!
    }
    
    ///当月的第一天
    var firstDayOfCurrentMonth: Date {
        
        var date = Date()
        var time: TimeInterval = 0
        let calendar = Calendar(identifier: .gregorian)
        let ok =  calendar.dateInterval(of: .month, start: &date, interval: &time, for: self)
        assert(ok, "Failed to calculate the first day of the month based on \(self)")
        return date
    }
    
    ///本周的第几天
    var weeklyOrdinality: Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .weekday, in: .weekOfMonth, for: self)! - 1
    }
    
    ///本月的第几天
    var monthlyOrdinality: Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .month, for: self)!
    }
    
    /// 当月有几周
    var numberOfWeeksInCurrenMonth: Int {
 
        let weekday = self.firstDayOfCurrentMonth.weeklyOrdinality
        
        var days = self.numberOfDaysInCurrentMonth
        var weeks = 0
        
        if weekday > 1 {
            weeks += 1
            days -= (7 - weekday + 1)
        }
        
        weeks += days / 7
        weeks += (days % 7 > 0) ? 1 : 0
        return weeks
    }
    
    /// 当月最后一天
    var lastDayOfCurrentMonth: Date {
        
        let calendarUnit: NSCalendar.Unit = [.year, .month, .day]
        var dateComponents: DateComponents = (Foundation.Calendar.current as NSCalendar).components(calendarUnit, from: self)
        dateComponents.day = self.numberOfDaysInCurrentMonth
        return Foundation.Calendar.current.date(from: dateComponents)!
    }
    
    var dayInThePreviousMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        return (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue:0))!
    }
    
    var dayInTheFollowingMonth: Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let newDate = (Foundation.Calendar.current as NSCalendar).date(byAdding: dateComponents, to: self, options: .matchStrictly)!
       
       return newDate
    }
    
    var YMDComponents: DateComponents {
        let unitFlags: NSCalendar.Unit = [.year, .month, .day]
        return (Foundation.Calendar.current as NSCalendar).components(unitFlags, from: self)
    }
    
    func weekNumberInCurrentMonth() ->Int {
        
        let firstDay = self.firstDayOfCurrentMonth.weeklyOrdinality
        
        let weeksCount = self.numberOfWeeksInCurrenMonth
        var weekNumber = 0
        
        let c = self.YMDComponents
        var startIndex = self.firstDayOfCurrentMonth.monthlyOrdinality
        var endIndex = startIndex + ( 7 - firstDay )
        for i in 0..<weeksCount {
            if c.day! >= startIndex && c.day! <= endIndex{
                weekNumber = i
            }
            startIndex = endIndex + 1
            endIndex = startIndex + 6
        }
        return weekNumber
    }
    
    
    ///日期的格式化字符串
    func stringWithDateFormat(_ dateFormat: String)->String {
       
        _zymeformatter.dateFormat = dateFormat
        _zymeformatter.calendar = self.calendar
        return _zymeformatter.string(from: self)
    }
    
    ///当月指定天数的日期
    func dateOfCurrentMonthWithNumber(_ day: Int) ->Date {
        var greCalendar = Calendar(identifier:.gregorian)
        greCalendar.timeZone = TimeZone(identifier: "GMT")!
        let set = Set<Calendar.Component>(arrayLiteral: .year, .month, .day)
        var  componemts = greCalendar.dateComponents(set, from: self)
        componemts.day = day
        let date = greCalendar.date(from: componemts)
        return date!
    }
    
    
    ///是否是同一天
    func isSameDay(_ date: Date) -> Bool {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let flag = calendar.isDate(self, equalTo: date, toGranularity: .day)
        return flag
    }
}
