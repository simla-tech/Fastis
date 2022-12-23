//
//  File.swift
//
//
//  Created by Ilya Kharlamov on 9/12/22.
//

import Foundation

extension Calendar {
    var lastWeekday: Int {
        let numDays = self.weekdaySymbols.count
        let res = (self.firstWeekday + numDays - 1) % numDays
        return res != 0 ? res : self.weekdaySymbols.count
    }
}
