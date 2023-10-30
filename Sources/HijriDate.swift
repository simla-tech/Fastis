//
//  File.swift
//  
//
//  Created by Eslam on 31/10/2023.
//

import Foundation

public let hijriMonths = [
    1: "Muharram", 2: "Safar", 3: "Rabi' al-Awwal", 4: "Rabi' al-Thani", 5: "Jumada al-Ula",
    6: "Jumada al-Akhirah", 7: "Rajab", 8: "Sha'ban", 9: "Ramadan", 10: "Shawwal",
    11: "Dhu al-Qidah", 12: "Dhu al-Hijjah"
]

public class HijriDate {
    var day: Int
    var month: Int
    var year: Int

    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }

    static func getHijriMonth(from date: Date) -> String? {
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        let components = calendar.dateComponents([.month], from: date)
        guard let monthNumber = components.month else { return nil }
        return hijriMonths[monthNumber]
    }

    // Function to convert Gregorian date to Hijri date
    static  func convertGregorianToHijri(date: Date) -> HijriDate {
        let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
        let day = islamicCalendar.component(.day, from: date)
        let month = islamicCalendar.component(.month, from: date)
        let year = islamicCalendar.component(.year, from: date)
        return HijriDate(day: day, month: month, year: year)
    }

}

