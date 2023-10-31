//
//  File.swift
//  
//
//  Created by Eslam on 31/10/2023.
//

import Foundation

public let hijriENMonths = [
    1: "Muharram", 2: "Safar", 3: "Rabi' al-Awwal", 4: "Rabi' al-Thani", 5: "Jumada al-Ula",
    6: "Jumada al-Akhirah", 7: "Rajab", 8: "Sha'ban", 9: "Ramadan", 10: "Shawwal",
    11: "Dhu al-Qidah", 12: "Dhu al-Hijjah"
]

public let hijriARMonths = [
    1: "محرم", 2: "سفر", 3: "ربيع الآول", 4: "ربيع الثاني", 5: "جماد الآول",
    6: "جماد الآخر", 7: "رجب", 8: "شعبان", 9: "رمضان", 10: "شوال",
    11: "ذو القعدة", 12: "ذو الحجة"
]
public class HijriDate {
    public var day: Int
    public var month: Int
    public  var year: Int

    init(day: Int, month: Int, year: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
//islamicUmmAlQura
    //gregorian
    static public func getHijriMonth(from date: Date,localIdentifier: String) -> String? {
        let calendar = Calendar(identifier: .islamicUmmAlQura)
        let components = calendar.dateComponents([.month], from: date)
        guard let monthNumber = components.month else { return nil }
        return localIdentifier == "ar_EG"  ? hijriARMonths[monthNumber] : hijriENMonths[monthNumber]
    }


    // Function to convert Gregorian date to Hijri date
    static public func convertGregorianToHijri(date: Date) -> HijriDate {
        let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
        let day = islamicCalendar.component(.day, from: date)
        let month = islamicCalendar.component(.month, from: date)
        let year = islamicCalendar.component(.year, from: date)
        return HijriDate(day: day, month: month, year: year)
    }

}

