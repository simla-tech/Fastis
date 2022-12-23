//
//  FastisValue.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

/// Mode of ``FastisValue`` entity
public enum FastisMode {
    case single
    case range
}

/// Value of ``FastisController``
public protocol FastisValue {

    /// Mode of value for ``FastisController``
    static var mode: FastisMode { get }

    /// Helper function for ``FastisController``
    func outOfRange(minDate: Date?, maxDate: Date?) -> Bool
}

/// Range value for ``FastisController``
public struct FastisRange: FastisValue, Hashable {

    /// Start of the range
    public var fromDate: Date

    /// End of the range
    public var toDate: Date

    /// Mode of value for ``FastisController``. Always `.range`
    public static let mode: FastisMode = .range

    /// Creates a new FastisRange
    /// - Parameters:
    ///   - fromDate: Start of the range
    ///   - toDate: End of the range
    public init(from fromDate: Date, to toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
    }

    public static func from(_ fromDate: Date, to toDate: Date) -> FastisRange {
        FastisRange(from: fromDate, to: toDate)
    }

    public var onSameDay: Bool {
        self.fromDate.isInSameDay(date: self.toDate)
    }

    public func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        self.fromDate < minDate ?? self.fromDate || self.toDate > maxDate ?? self.toDate
    }

}

public enum FastisModeSingle {
    case single
}

public enum FastisModeRange {
    case range
}

extension Date: FastisValue {

    /// Mode of value for ``FastisController``. Always `.single`
    public static var mode: FastisMode = .single

    public func outOfRange(minDate: Date?, maxDate: Date?) -> Bool {
        self < minDate ?? self || self > maxDate ?? self
    }

}
