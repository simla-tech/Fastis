//
//  Shortcut.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

public struct FastisShortcut<Value: FastisValue>: Hashable {

    private var id: UUID = UUID()
    public var name: String
    public var action: () -> Value

    public init(name: String, action: @escaping () -> Value) {
        self.name = name
        self.action = action
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    public static func == (lhs: FastisShortcut<Value>, rhs: FastisShortcut<Value>) -> Bool {
        return lhs.id == rhs.id
    }

    internal func isEqual(to value: Value) -> Bool {
        if let date1 = self.action() as? Date, let date2 = value as? Date {
            return date1.isInSameDay(date: date2)
        } else if let value1 = self.action() as? FastisRange, let value2 = value as? FastisRange {
            return value1 == value2
        }
        return false
    }

}

extension FastisShortcut where Value == FastisRange {

    public static var today: FastisShortcut {
        return FastisShortcut(name: "Today") {
            let now = Date()
            return FastisRange(from: now.startOfDay(), to: now.endOfDay())
        }
    }

    public static var lastWeek: FastisShortcut {
        return FastisShortcut(name: "Last week") {
            let now = Date()
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            return FastisRange(from: weekAgo.startOfDay(), to: now.endOfDay())
        }
    }

    public static var lastMonth: FastisShortcut {
        return FastisShortcut(name: "Last month") {
            let now = Date()
            let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            return FastisRange(from: monthAgo.startOfDay(), to: now.endOfDay())
        }
    }

}

extension FastisShortcut where Value == Date {

    public static var today: FastisShortcut {
        return FastisShortcut(name: "Today") {
            return Date()
        }
    }

    public static var yesterday: FastisShortcut {
        return FastisShortcut(name: "Yesterday") {
            return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        }
    }

    public static var tomorrow: FastisShortcut {
        return FastisShortcut(name: "Tomorrow") {
            return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        }
    }

}
