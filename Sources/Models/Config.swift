//
//  Config.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

/// Main configuration file
public struct FastisConfig {

    /**
     The default configuration.

     Fastis can be customized global or local.

     Modify this variable to customize all Fastis controllers in your app:
     ```swift
     FastisConfig.default.monthHeader.labelColor = .red
     ```

     Or you can copy and modify this config for some special controller:
     ```swift
     let config: FastisConfig = .default
     config.monthHeader.labelColor = .red
     let controller = FastisController(mode: .single, config: config)
     ```
     */
    public static var `default` = FastisConfig()

    private init() { }

    /**
     Base calendar used to build a view

     Default value — `.current`
     */
    public var calendar: Calendar = .current

    /// Base view controller (`cancelButtonTitle`, `doneButtonTitle`, etc.)
    public var controller = FastisConfig.Controller()

    /// Month titles
    public var monthHeader = FastisConfig.MonthHeader()

    /// Day cells (selection parameters, font, etc.)
    public var dayCell = FastisConfig.DayCell()

    /// Top header view with week day names
    public var weekView = FastisConfig.WeekView()

    /// Current value view appearance (clear button, date format, etc.)
    public var currentValueView = FastisConfig.CurrentValueView()

    /// Bottom view with shortcuts
    public var shortcutContainerView = FastisConfig.ShortcutContainerView()

    /// Shortcut item in the bottom view
    public var shortcutItemView = FastisConfig.ShortcutItemView()

}
