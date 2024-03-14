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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showRangeCalendar) {
            self.rangeCalendarView()
        }
        .sheet(isPresented: $showSingleCalendar) {
            self.singleCalendarView()
        }
    }

    private func rangeCalendarView() -> some View {
        let config: FastisConfig = .default
        var fastisView = FastisView(mode: .range, config: config)
        fastisView.title = "Choose range"
        fastisView.initialValue = self.currentValue as? FastisRange
        fastisView.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        fastisView.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        fastisView.allowToChooseNilDate = true
        fastisView.allowDateRangeChanges = false
        fastisView.shortcuts = [.lastWeek, .lastMonth]
        fastisView.selectMonthOnHeaderTap = true

        fastisView.dismissHandler = { action in
            switch action {
            case .done(let newValue):
                self.currentValue = newValue
            case .cancel:
                print("any actions")
            }
        }
        return fastisView.ignoresSafeArea()
    }

    private func singleCalendarView() -> some View {
        let config: FastisConfig = .default
        var fastisView = FastisView(mode: .single, config: config)
        fastisView.title = "Choose date"
        fastisView.initialValue = self.currentValue as? Date
        fastisView.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        fastisView.maximumDate = Date()
        fastisView.allowToChooseNilDate = true
        fastisView.allowDateRangeChanges = false
        fastisView.shortcuts = [.yesterday, .today, .tomorrow]
        fastisView.closeOnSelectionImmediately = true

        fastisView.dismissHandler = { action in
            switch action {
            case .done(let newValue):
                self.currentValue = newValue
            case .cancel:
                print("any actions")
            }
        }
        return fastisView.ignoresSafeArea()
    }

}
