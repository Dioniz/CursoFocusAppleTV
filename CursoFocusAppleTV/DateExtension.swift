//
//  DateExtension.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 21/3/23.
//

import Foundation
import AVKit

extension Date {

    static func getStringDate(from: String, format: String) -> String {
        var result = ""

        if let unixStartTime = Double(from) {
            let startDate = Date(timeIntervalSince1970: unixStartTime)
            let locale = Locale(identifier: "es_ES")
            let start = Calendar.current.startOfDay(for: startDate)
            let customFormatter = buildFormatter(locale: locale, dateFormat: format)
            result = dateFormatterToString(customFormatter, startDate)


        }

        return result
    }

    static func getStringDate(stringDate: String) -> String {
        let string = (stringDate.count>10) ? stringDate.take(10) : stringDate
        var result = ""
        if let unixTime = Double(string){
            let date = Date(timeIntervalSince1970: unixTime)

            let locale = NSLocale.current
            let customFormatter = buildFormatter(locale: locale, dateFormat: "dd-MM-YYYY")
            let customDateString = dateFormatterToString(customFormatter, date)

            result = "\(customDateString)"
        }

        return result
    }
    
    static func buildFormatter(locale: Locale, hasRelativeDate: Bool = false, dateFormat: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        if let dateFormat = dateFormat { formatter.dateFormat = dateFormat }
        formatter.doesRelativeDateFormatting = hasRelativeDate
        formatter.locale = locale
        return formatter
    }

    static func dateFormatterToString(_ formatter: DateFormatter, _ date: Date) -> String {
        return formatter.string(from: date)
    }

    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
