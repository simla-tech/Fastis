//
//  Shortcut.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

/**
 Using shortcuts allows you to quick select prepared dates or date ranges.
 By default `.shortcuts` is empty. If you don't provide any shortcuts the bottom container will be hidden.

 In Fastis available some prepared shortcuts for each mode:

 - For **`.single`**: `.today`, `.tomorrow`, `.yesterday`
 - For **`.range`**: `.today`, `.lastWeek`, `.lastMonth`

 Also you can create your own shortcut:

 ```swift
 var customShortcut = FastisShortcut(name: "Today") {
     let now = Date()
     return FastisRange(from: now.startOfDay(), to: now.endOfDay())
 }
 fastisController.shortcuts = [customShortcut, .lastWeek]
 ```
 */
public struct FastisShortcut<Value: FastisValue>: Hashable {

    private var id = UUID()

    /// Display name of shortcut
    public var name: String

    /// Tap handler
    public var action: () -> Value

    /// Create a shortcut
    /// - Parameters:
    ///   - name: Display name of shortcut
    ///   - action: Tap handler
    public init(name: String, action: @escaping () -> Value) {
        self.name = name
        self.action = action
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    public static func == (lhs: FastisShortcut<Value>, rhs: FastisShortcut<Value>) -> Bool {
        lhs.id == rhs.id
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

public extension FastisShortcut where Value == FastisRange {

    /// Range: from **`now.startOfDay`** to **`now.endOfDay`**
    static var today: FastisShortcut {
        FastisShortcut(name: "Today") {
            let now = Date()
            return FastisRange(from: now.startOfDay(), to: now.endOfDay())
        }
    }

    /// Range: from **`now.startOfDay - 7 days`** to **`now.endOfDay`**
    static var lastWeek: FastisShortcut {
        FastisShortcut(name: "Last week") {
            let now = Date()
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            return FastisRange(from: weekAgo.startOfDay(), to: now.endOfDay())
        }
    }

    /// Range: from **`now.startOfDay - 1 month`** to **`now.endOfDay`**
    static var lastMonth: FastisShortcut {
        FastisShortcut(name: "Last month") {
            let now = Date()
            let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            return FastisRange(from: monthAgo.startOfDay(), to: now.endOfDay())
        }
    }

}

public extension FastisShortcut where Value == Date {

    /// Date value: **`now`**
    static var today: FastisShortcut {
        FastisShortcut(name: "Today") {
            Date()
        }
    }

    /// Date value: **`now - .day(1)`**
    static var yesterday: FastisShortcut {
        FastisShortcut(name: "Yesterday") {
            Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        }
    }

    /// Date value: **`now + .day(1)`**
    static var tomorrow: FastisShortcut {
        FastisShortcut(name: "Tomorrow") {
            Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        }
    }

}
