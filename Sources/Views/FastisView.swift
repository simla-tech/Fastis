//
//  FastisView.swift
//  FastisExample
//
//  Created by Yriy Devyataev on 13.03.2024.
//  Copyright © 2024 RetailDriver LLC. All rights reserved.
//

import SwiftUI

/**
  View  of Fastis framework. Use it to create and present dade picker

  **Single and range modes**

  If you want to get a single date you have to use `Date` type:

  ```swift
 FastisView(mode: .single, dismissHandler: { action in
     switch action {
     case .done(let resultDate):
        print(resultDate) // resultDate is Date
     case .cancel:
        ...
     }
 })
 .initialValue(Date())
 .closeOnSelectionImmediately(true)
  ```

  If you want to get a date range you have to use `FastisRange` type:

  ```swift
 FastisView(mode: .range, dismissHandler: { action in
     switch action {
     case .done(let resultRange):
        print(resultRange) // resultRange is FastisRange
     case .cancel:
        ...
     }
  })
  .initialValue(FastisRange(from: Date(), to: Date())) // or .from(Date(), to: Date())
  ```
  */
public struct FastisView<Value: FastisValue>: UIViewControllerRepresentable {

    private let controller: FastisController<Value>

    /// Initiate FastisView
    /// - Parameter config: Configuration parameters
    /// - Parameter dismissHandler: The block to execute after the dismissal finishes, return two variable .done(FastisValue?) and .cancel
    public init(
        config: FastisConfig = .default,
        dismissHandler: ((FastisController<Value>.DismissAction) -> Void)? = nil
    ) {
        self.controller = FastisController<Value>(config: config)
        self.controller.dismissHandler = dismissHandler
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: self.controller)
    }

    public func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: UIViewControllerRepresentableContext<FastisView>
    ) { }

    /**
     Title of view

     Default value — `"nil"`
     */
    public func title(_ value: String?) -> Self {
        self.controller.title = value
        return self
    }

    /**
     And initial value which will be selected by default

     Default value — `"nil"`
     */
    public func initialValue(_ value: Value?) -> Self {
        self.controller.initialValue = value
        return self
    }

    /**
     Minimal selection date. Dates less then current will be marked as unavailable

     Default value — `"nil"`
     */
    public func minimumDate(_ value: Date?) -> Self {
        self.controller.minimumDate = value
        return self
    }

    /**
     Maximum selection date. Dates greater then current will be marked as unavailable

     Default value — `"nil"`
     */
    public func maximumDate(_ value: Date?) -> Self {
        self.controller.maximumDate = value
        return self
    }

    /**
     Allow to choose `nil` date

     When `allowToChooseNilDate` is `true`:
     * "Done" button will be always enabled
     * You will be able to reset selection by you tapping on selected date again

     Default value — `"false"`
     */
    public func allowToChooseNilDate(_ value: Bool) -> Self {
        self.controller.allowToChooseNilDate = value
        return self
    }

    /**
     Shortcuts array

     Default value — `"[]"`

     You can use prepared shortcuts depending on the current mode.

     - For `.single` mode: `.today`, `.tomorrow`, `.yesterday`
     - For `.range` mode: `.today`, `.lastWeek`, `.lastMonth`

     Or you can create your own shortcuts:

     ```
     var customShortcut = FastisShortcut(name: "Today") {
         let now = Date()
         return FastisRange(from: now.startOfDay(), to: now.endOfDay())
     }
     ```
     */
    public func shortcuts(_ value: [FastisShortcut<Value>]) -> Self {
        self.controller.shortcuts = value
        return self
    }

}

public extension FastisView where Value == FastisRange {

    /// Initiate FastisView
    /// - Parameters:
    ///   - mode: Choose `.range` or `.single` mode
    ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    init(
        mode: FastisModeRange,
        config: FastisConfig = .default,
        dismissHandler: ((FastisController<Value>.DismissAction) -> Void)? = nil
    ) {
        self.init(config: config, dismissHandler: dismissHandler)
    }

    /**
     Allow date range changes

     Set this variable to `false` if you want to disable date range changes.
     Next tap after selecting range will start new range selection.

     Default value — `"true"`
     */
    func allowDateRangeChanges(_ value: Bool) -> Self {
        self.controller.allowDateRangeChanges = value
        return self
    }

    /**
     Set this variable to `true` if you want to allow select date ranges by tapping on months

     Default value — `"false"`
     */
    func selectMonthOnHeaderTap(_ value: Bool) -> Self {
        self.controller.selectMonthOnHeaderTap = value
        return self
    }

}

public extension FastisView where Value == Date {

    /// Initiate FastisView
    /// - Parameters:
    ///   - mode: Choose `.range` or `.single` mode
    ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    ///   - dismissHandler: The block to execute after the dismissal finishes, return two variable .done(FastisValue?) and .cancel
    init(
        mode: FastisModeSingle,
        config: FastisConfig = .default,
        dismissHandler: ((FastisController<Value>.DismissAction) -> Void)? = nil
    ) {
        self.init(config: config, dismissHandler: dismissHandler)
    }

    /**
     Set this variable to `true` if you want to hide view of the selected date and close the controller right after the date is selected.

     Default value — `"false"`
     */
    func closeOnSelectionImmediately(_ value: Bool) -> Self {
        self.controller.closeOnSelectionImmediately = value
        return self
    }

}
