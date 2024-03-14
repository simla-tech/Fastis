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
 ```swift
 let fastisView = FastisView(mode: .range)
 fastisView.title = "Choose range"
 fastisView.maximumDate = Date()
 fastisView.allowToChooseNilDate = true
 fastisView.shortcuts = [.today, .lastWeek]
 fastisView.dismissHandler = { [weak self] action in
     switch action {
     case .done(let newValue):
        ...
     case .cancel:
        ...
     }
 }
 ```

 **Single and range modes**

 If you want to get a single date you have to use `Date` type:

 ```swift
 let fastisView = FastisView(mode: .single)
 fastisView.initialValue = Date()
 fastisView.closeOnSelectionImmediately = true
 fastisView.dismissHandler = { [weak self] action in
     switch action {
     case .done(let resultDate):
        print(resultDate) // resultDate is Date
     case .cancel:
        ...
     }
 }
 ```

 If you want to get a date range you have to use `FastisRange` type:

 ```swift
 let fastisView = FastisView(mode: .range)
 fastisView.initialValue = FastisRange(from: Date(), to: Date()) // or .from(Date(), to: Date())
 fastisView.dismissHandler = { [weak self] action in
     switch action {
     case .done(let resultRange):
        print(resultRange) // resultRange is FastisRange
     case .cancel:
        ...
     }
 }
 ```
 */

public struct FastisView<Value: FastisValue>: UIViewControllerRepresentable {

    public var title: String? = nil
    public var initialValue: Value? = nil
    public var minimumDate: Date? = nil
    public var maximumDate: Date? = nil
    public var allowToChooseNilDate: Bool = false
    public var allowDateRangeChanges: Bool = true
    public var shortcuts: [FastisShortcut<Value>] = []
    public var dismissHandler: ((FastisController<Value>.DismissAction) -> Void)? = nil

    private var privateSelectMonthOnHeaderTap = false
    private var privateCloseOnSelectionImmediately = false

    private let config: FastisConfig

    /// Initiate FastisView
    /// - Parameter config: Configuration parameters
    init(config: FastisConfig = .default) {
        self.config = config
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
    init(mode: FastisModeRange, config: FastisConfig = .default) {
        self.init(config: config)
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
    init(mode: FastisModeSingle, config: FastisConfig = .default) {
        self.init(config: config)
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
