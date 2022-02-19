//
//  Config.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

public struct FastisConfig {

    public static var `default` = FastisConfig()

    private init() {}

    public var controller = FastisConfig.Controller()
    public var monthHeader = FastisConfig.MonthHeader()
    public var dayCell = FastisConfig.DayCell()
    public var weekView = FastisConfig.WeekView()
    public var currentValueView = FastisConfig.CurrentValueView()
    public var shortcutContainerView = FastisConfig.ShortcutContainerView()
    public var shortcutItemView = FastisConfig.ShortcutItemView()

}
