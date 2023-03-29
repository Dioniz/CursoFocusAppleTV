//
//  StringExtension.swift
//  CursoAppleTV
//
//  Created by Fran Dioniz on 21/3/23.
//

import Foundation
import UIKit

extension String {
    
    static func createDateTime(timestamp: String) -> String {
        var strDate = "-"
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"
            dateFormatter.timeZone = TimeZone(abbreviation: timezone)
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "HH:mm"
            strDate = dateFormatter.string(from: date)
        }
        return "\(strDate)h"
    }
    
    static func getDateStringWithFormat(date:Date, formatString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: date)
    }

    func take(_ n: Int) -> String {
        guard n >= 0 else {
            fatalError("n should never negative")
        }
        let index = self.index(self.startIndex, offsetBy: min(n, self.count))
        return String(self[..<index])
    }

    /**
        Returns an attributted string with the specific font and color
    */
    static func getAttributedText(text: String, font:UIFont = .systemFont(ofSize: 26), color:UIColor = UIColor.white) -> NSMutableAttributedString{
        let normalDict = NSMutableDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let attributedString = NSMutableAttributedString(string: text, attributes: normalDict as? [NSAttributedString.Key : Any])
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: NSMakeRange(0,text.count))
        return attributedString
    }
}
