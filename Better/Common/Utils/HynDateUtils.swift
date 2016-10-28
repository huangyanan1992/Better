//
//  HynDateUtils.swift
//  Better
//
//  Created by Huang Yanan on 2016/10/21.
//  Copyright © 2016年 Huang Yanan. All rights reserved.
//

import Foundation

fileprivate let D_Minute:TimeInterval = 60
fileprivate let D_Hour:TimeInterval = D_Minute*60
fileprivate let D_Day:TimeInterval = D_Hour*24

fileprivate let yyyy_mm_dd = "yyyy-MM-dd"
fileprivate let yyyy_mm_dd2 = "yyyy/MM/dd"
fileprivate let mm_dd = "MM-dd"
fileprivate let hh_mm_ss = "HH:mm:ss"
fileprivate let hh_mm = "HH:mm"

extension Date {
    
    /// 年
    func year() -> Int? {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return currentDateComponents.year
    }
    
    /// 月
    func month() -> Int? {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return currentDateComponents.month
    }
    
    /// 日
    func day() -> Int? {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return currentDateComponents.day
    }
    
    /// 时
    func hour() -> Int? {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return currentDateComponents.hour
    }
    
    /// 分
    func minute() -> Int? {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return currentDateComponents.minute
    }
    
    /// 秒
    func second() -> Int? {
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        return currentDateComponents.second
    }
    
    /// 几小时后
    func hoursLater(hour:TimeInterval) -> Date {
        return self.addingTimeInterval(hour*D_Hour)
    }
    
    /// 几小时前
    func hoursAgo(hour:TimeInterval) -> Date {
        return hoursLater(hour: -hour)
    }
    
    /// 几分钟后
    func minuteLater(minute:TimeInterval) -> Date {
        return self.addingTimeInterval(minute*D_Minute)
    }
    
    /// 几分钟前
    func minuteAgo(minute:TimeInterval) -> Date {
        return minuteLater(minute: -minute)
    }
    
    /// 返回日期时间格式1 yyyy-mm-dd hh:mm:ss
    func dateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String(format: "%@ %@", yyyy_mm_dd,hh_mm_ss)
        return  dateFormatter.string(from: self)
    }
    
    /// 返回日期时间格式2 yyyy/mm/dd hh:mm:ss
    func dateTimeString2() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String(format: "%@ %@", yyyy_mm_dd2,hh_mm_ss)
        return  dateFormatter.string(from: self)
    }
    
    /// 返回日期时间格式3 mm-dd hh:mm
    func dateTimeString3() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String(format: "%@ %@", mm_dd,hh_mm)
        return  dateFormatter.string(from: self)
    }
    
    /// 返回日期格式1 yyyy-mm-dd
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String(format: "%@", yyyy_mm_dd)
        return  dateFormatter.string(from: self)
    }
    
    /// 返回时间格式1 hh_mm
    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String(format: "%@", hh_mm)
        return  dateFormatter.string(from: self)
    }
    
    
    /// 根据字符串返回时间特定时间格式
    ///
    /// - parameter string: 时间字符串
    ///
    /// - returns: yyyy-mm-dd hh:mm:ss
    static func dateByString(string:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String(format: "%@ %@", yyyy_mm_dd,hh_mm_ss)
        return dateFormatter.date(from: string)!
    }
    
    func isCurrentYear() -> Bool {
        return year() == Date().year()
    }
    
    /// 是否是今天
    func isToday() -> Bool {
        return self.dateString() == Date().dateString()
    }
    
    /// 加几天
    ///
    /// - parameter day: 天数
    ///
    /// - returns: 增加后的日期
    func addDay(day:Int) -> Date {
        return self.addingTimeInterval(TimeInterval(day)*24*D_Hour)
    }
    
    func subDay(day:Int) -> Date {
        return self.addDay(day: -day)
    }
    
    
    /// 是否是昨天
    ///
    /// - returns: true:是，false:否
    func isYesterday() -> Bool {
        return addDay(day: 1).isToday()
    }
    
    /// 是否是前天
    ///
    /// - returns: true：是，false：否
    func isBeforeYesterDay() -> Bool {
        return addDay(day: 2).isToday()
    }
    
    /// 是否是昨天之前一周之内
    ///
    /// - returns: true：是，false：不是
    func isWeakAgo() -> Bool {
        print(self.addDay(day: 7).timeIntervalSince1970)
        print(Date().timeIntervalSince1970 - TimeInterval(Date().hour()!)*D_Hour-TimeInterval(Date().minute()!)*D_Minute - TimeInterval(Date().second()!))
        return self.addDay(day: 7).timeIntervalSince1970 - (Date().timeIntervalSince1970 - TimeInterval(Date().hour()!)*D_Hour-TimeInterval(Date().minute()!)*D_Minute - TimeInterval(Date().second()!)) < 0
    }
    
    /// 多久前
    ///
    /// - returns: 几分钟，几小时，几天前
    func timesAgo() -> String {
        if isToday() {
            let timeInterval = Date().timeIntervalSince1970 - self.timeIntervalSince1970
            if timeInterval >= D_Hour {
                return String.init(format: "%d小时前", timeInterval/D_Hour)
            }
            else {
                guard timeInterval >= D_Minute else {
                    return "刚刚"
                }
                return String.init(format: "%d分钟前", timeInterval/D_Minute)
            }
        }
        else if isYesterday() {
            return "昨天"
        }
        else if isBeforeYesterDay() {
            return "前天"
        }
        else if addDay(day: 3).isToday() {
            return "3天前"
        }
        else if addDay(day: 4).isToday() {
            return "4天前"
        }
        else if addDay(day: 5).isToday() {
            return "5天前"
        }
        else if addDay(day: 6).isToday() {
            return "6天前"
        }
        else if isWeakAgo() {
            return dateTimeString3()
        }
        else {
            return "刚刚"
        }
    }
    
}
