//
//  CalendarView.swift
//  FastisExample
//
//  Created by Yriy Devyataev on 13.03.2024.
//  Copyright © 2024 RetailDriver LLC. All rights reserved.
//


import Foundation
import SwiftUI
import UIKit
import Fastis

/**
 View is used as a possible example of a SwiftUI project.
 */

struct MainView: View {

    @State private var showSingleCalendar = false
    @State private var showRangeCalendar = false
    @State private var currentValueText: String = "Choose a date"

    @State var currentValue: FastisValue? {
        didSet {
            if let rangeValue = self.currentValue as? FastisRange {
                self.currentValueText = self.dateFormatter.string(from: rangeValue.fromDate) + " - " + self.dateFormatter.string(from: rangeValue.toDate)
            } else if let date = self.currentValue as? Date {
                self.currentValueText = self.dateFormatter.string(from: date)
            } else {
                self.currentValueText = "Choose a date"
            }
        }
    }

    @State private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

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
        .sheet(isPresented: $showRangeCalendar) {
            FastisView(mode: .range) { action in
                switch action {
                case .done(let newValue):
                    self.currentValue = newValue
                case .cancel:
                    print("any actions")
                }
            }
            .title("Choose range")
            .initialValue(self.currentValue as? FastisRange)
            .minimumDate(Calendar.current.date(byAdding: .month, value: -2, to: Date()))
            .maximumDate(Calendar.current.date(byAdding: .month, value: 3, to: Date()))
            .allowToChooseNilDate(true)
            .allowDateRangeChanges(false)
            .shortcuts([.lastWeek, .lastMonth])
            .selectMonthOnHeaderTap(true)
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showSingleCalendar) {
            FastisView(mode: .single) { action in
                switch action {
                case .done(let newValue):
                    self.currentValue = newValue
                case .cancel:
                    print("any actions")
                }
            }
            .title("Choose date")
            .initialValue(self.currentValue as? Date)
            .minimumDate(Calendar.current.date(byAdding: .month, value: -2, to: Date()))
            .maximumDate(Date())
            .allowToChooseNilDate(true)
            .allowDateRangeChanges(false)
            .shortcuts([.yesterday, .today, .tomorrow])
            .closeOnSelectionImmediately(true)
            .ignoresSafeArea()
        }
    }
}
