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

 Usage example:
 ```swiftUI
 FastisView(mode: .range) { action in
    switch action {
        case .done(let newValue):
            ...
        case .cancel:
            ...
    }
 }
 .title = "Choose range"
 .maximumDate = Date()
 .allowToChooseNilDate = true
 .shortcuts = [.today, .lastWeek]
 ```

 **Single and range modes**

 If you want to get a single date you have to use `Date` type:

 ```swiftUI
FastisView(mode: .single) { action in
    switch action {
        case .done(let resultDate):
            print(resultDate) // resultDate is Date
        case .cancel:
            ...
    }
}
.initialValue = Date()
.closeOnSelectionImmediately = true
 ```

 If you want to get a date range you have to use `FastisRange` type:

 ```swiftUI
FastisView(mode: .range) { action in
    switch action {
        case .done(let resultRange):
            print(resultRange) // resultRange is FastisRange
        case .cancel:
            ...
    }
 }
.initialValue = FastisRange(from: Date(), to: Date()) // or .from(Date(), to: Date())
 ```
 */

public struct FastisView<Value: FastisValue>: UIViewControllerRepresentable {

    private var privateSelectMonthOnHeaderTap = false
    private var privateCloseOnSelectionImmediately = false
    private let config: FastisConfig

    /**
     And title controller
     */
    public var title: String? = nil

    /**
     And initial value which will be selected by default
     */
    public var initialValue: Value? = nil

    /**
     Minimal selection date. Dates less then current will be marked as unavailable
     */
    public var minimumDate: Date? = nil
    
    /**
     Maximum selection date. Dates greater then current will be marked as unavailable
     */
    public var maximumDate: Date? = nil

    /**
     Allow to choose `nil` date

     When `allowToChooseNilDate` is `true`:
     * "Done" button will be always enabled
     * You will be able to reset selection by you tapping on selected date again
     */
    public var allowToChooseNilDate: Bool = false

    /**
     Allow date range changes

     Set this variable to `false` if you want to disable date range changes.
     Next tap after selecting range will start new range selection.
     */
    public var allowDateRangeChanges: Bool = true

    /**
     Shortcuts array

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
    public var shortcuts: [FastisShortcut<Value>] = []

    /**
     The block to execute after the dismissal finishes, return two variable .done(FastisValue?) and .cancel
     */
    public var dismissHandler: ((FastisController<Value>.DismissAction) -> Void)? = nil

    /// Initiate FastisView
    /// - Parameter config: Configuration parameters
    public init(
        config: FastisConfig = .default,
        dismissHandler: ((FastisController<Value>.DismissAction) -> Void)? = nil
    ) {
        self.config = config
        self.dismissHandler = dismissHandler
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        let fastisController = FastisController<Value>(config: self.config)
        fastisController.title = self.title
        fastisController.initialValue = self.initialValue
        fastisController.minimumDate = self.minimumDate
        fastisController.maximumDate = self.maximumDate
        fastisController.allowToChooseNilDate = self.allowToChooseNilDate
        fastisController.allowDateRangeChanges = self.allowDateRangeChanges
        fastisController.shortcuts = self.shortcuts
        fastisController.dismissHandler = self.dismissHandler
        switch Value.mode {
        case .single:
            let singleController = fastisController as? FastisController<Date>
            singleController?.closeOnSelectionImmediately = self.privateCloseOnSelectionImmediately
        case .range:
            let rangeController = fastisController as? FastisController<FastisRange>
            rangeController?.selectMonthOnHeaderTap = self.privateSelectMonthOnHeaderTap
        }
        return UINavigationController(rootViewController: fastisController)
    }

    public func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: UIViewControllerRepresentableContext<FastisView>
    ) {}
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
     Set this variable to `true` if you want to allow select date ranges by tapping on months
     */
    var selectMonthOnHeaderTap: Bool {
        get {
            self.privateSelectMonthOnHeaderTap
        }
        set {
            self.privateSelectMonthOnHeaderTap = newValue
        }
    }
}

public extension FastisView where Value == Date {

    /// Initiate FastisView
    /// - Parameters:
    ///   - mode: Choose .range or .single mode
    ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    init(
        mode: FastisModeSingle,
        config: FastisConfig = .default,
        dismissHandler: ((FastisController<Value>.DismissAction) -> Void)? = nil
    ) {
        self.init(config: config, dismissHandler: dismissHandler)
    }

    /**
     Set this variable to `true` if you want to hide view of the selected date and close the controller right after the date is selected.

     Default value — `"False"`
     */
    var closeOnSelectionImmediately: Bool {
        get {
            self.privateCloseOnSelectionImmediately
        }
        set {
            self.privateCloseOnSelectionImmediately = newValue
        }
    }
}

public extension FastisView {

    /// Modifier for property 'title'
    func title(_ value: String?) -> FastisView<Value> {
        var view = self
        view.title = value
        return view
    }

    /// Modifier for property 'initialValue'
    func initialValue(_ value: Value?) -> FastisView<Value> {
        var view = self
        view.initialValue = value
        return view
    }

    /// Modifier for property 'minimumDate'
    func minimumDate(_ value: Date?) -> FastisView<Value> {
        var view = self
        view.minimumDate = value
        return view
    }

    /// Modifier for property 'maximumDate'
    func maximumDate(_ value: Date?) -> FastisView<Value> {
        var view = self
        view.maximumDate = value
        return view
    }

    /// Modifier for property 'allowToChooseNilDate'
    func allowToChooseNilDate(_ value: Bool) -> FastisView<Value> {
        var view = self
        view.allowToChooseNilDate = value
        return view
    }

    /// Modifier for property 'allowDateRangeChanges'
    func allowDateRangeChanges(_ value: Bool) -> FastisView<Value> {
        var view = self
        view.allowDateRangeChanges = value
        return view
    }

    /// Modifier for property 'shortcuts'
    func shortcuts(_ value: [FastisShortcut<Value>]) -> FastisView<Value> {
        var view = self
        view.shortcuts = value
        return view
    }
}

public extension FastisView where Value == FastisRange {

    /// Modifier for property 'selectMonthOnHeaderTap'
    func selectMonthOnHeaderTap(_ value: Bool) -> FastisView<Value> {
        var view = self
        view.selectMonthOnHeaderTap = value
        return view
    }
}

public extension FastisView where Value == Date {

    /// Modifier for property 'closeOnSelectionImmediately'
    func closeOnSelectionImmediately(_ value: Bool) -> FastisView<Value> {
        var view = self
        view.closeOnSelectionImmediately = value
        return view
    }
}
