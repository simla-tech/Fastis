//
//  Date + Utilits.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

extension Date {

    internal func startOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!.startOfDay(in: calendar)
    }

    internal func endOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(in: calendar))!.endOfDay(in: calendar)
    }

    internal func isInSameDay(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: .day)
    }

    internal func isInSameMonth(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.component(.month, from: self) == calendar.component(.month, from: date)
    }

    internal func startOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    internal func endOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

}
