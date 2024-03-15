//
//  CalendarView.swift
//  FastisExample
//
//  Created by Yriy Devyataev on 13.03.2024.
//  Copyright © 2024 RetailDriver LLC. All rights reserved.
//

import Fastis
import Foundation
import SwiftUI
import UIKit

/**
 View is used as a possible example of a SwiftUI project.
 */
struct MainView: View {

    private let calendar: Calendar = .current

    @State private var showSingleCalendar = false
    @State private var showRangeCalendar = false
    @State private var currentValueText = "Choose a date"

    @State var currentValue: FastisValue? {
        didSet {
            if let rangeValue = self.currentValue as? FastisRange {
                self.currentValueText = self.dateFormatter.string(from: rangeValue.fromDate) + " - " + self.dateFormatter
                    .string(from: rangeValue.toDate)
            } else if let date = self.currentValue as? Date {
                self.currentValueText = self.dateFormatter.string(from: date)
            } else {
                self.currentValueText = "Choose a date"
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = self.calendar
        return formatter
    }

    var body: some View {
        VStack(spacing: 32, content: {
            Text(self.currentValueText)
            VStack(alignment: .center, spacing: 16, content: {
                Button("Choose range of dates") {
                    self.showRangeCalendar.toggle()
                }
                Button("Choose single date") {
                    self.showSingleCalendar.toggle()
                }
            })
        })
        .navigationTitle("SwiftUI presentation")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: self.$showRangeCalendar) {
            FastisView(mode: .range) { action in
                if case .done(let newValue) = action {
                    self.currentValue = newValue
                }
            }
            .title("Choose range")
            .initialValue(self.currentValue as? FastisRange)
            .minimumDate(self.calendar.date(byAdding: .month, value: -2, to: Date()))
            .maximumDate(self.calendar.date(byAdding: .month, value: 3, to: Date()))
            .allowToChooseNilDate(true)
            .allowDateRangeChanges(false)
            .shortcuts([.lastWeek, .lastMonth])
            .selectMonthOnHeaderTap(true)
            .ignoresSafeArea()
        }
        .sheet(isPresented: self.$showSingleCalendar) {
            FastisView(mode: .single) { action in
                if case .done(let newValue) = action {
                    self.currentValue = newValue
                }
            }
            .title("Choose date")
            .initialValue(self.currentValue as? Date)
            .minimumDate(self.calendar.date(byAdding: .month, value: -2, to: Date()))
            .maximumDate(Date())
            .allowToChooseNilDate(true)
            .shortcuts([.yesterday, .today, .tomorrow])
            .closeOnSelectionImmediately(true)
            .ignoresSafeArea()
        }
    }
}
