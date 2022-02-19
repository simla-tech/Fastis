//
//  FastisValue.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

public enum FastisMode {
    case single, range
}

public protocol FastisValue {
    static var mode: FastisMode { get set }
    func outOfRange(minDate: Date?, maxDate: Date?) -> Bool
}

public struct FastisRange: FastisValue, Hashable {

    public var fromDate: Date
    public var toDate: Date

    public static var mode: FastisMode = .range

    public init(from fromDate: Date, to toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
    }

    public static func from(_ fromDate: Date, to toDate: Date) -> FastisRange {
        return FastisRange(from: fromDate, to: toDate)
    }

    public var onSameDay: Bool {
        return self.fromDate.isInSameDay(date: self.toDate)
    }

    public func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        return self.fromDate < minDate ?? self.fromDate || self.toDate > maxDate ?? self.toDate
    }

}

public enum FastisModeSingle {
    case single
}

public enum FastisModeRange {
    case range
}

extension Date: FastisValue {
    public static var mode: FastisMode = .single

    public func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        return self < minDate ?? self || self > maxDate ?? self
    }

}
