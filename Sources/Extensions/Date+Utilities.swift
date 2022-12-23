//
//  Date+Utilities.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

extension Date {

    func startOfMonth(in calendar: Calendar = .current) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!.startOfDay(in: calendar)
    }

    func endOfMonth(in calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(in: calendar))!.endOfDay(in: calendar)
    }

    func isInSameDay(in calendar: Calendar = .current, date: Date) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: .day)
    }

    func isInSameMonth(in calendar: Calendar = .current, date: Date) -> Bool {
        calendar.component(.month, from: self) == calendar.component(.month, from: date)
    }

    func startOfDay(in calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    func endOfDay(in calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

}
