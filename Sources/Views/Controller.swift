//
//  FastisController.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SnapKit

public class FastisController<Value: FastisValue>: UIViewController, JTACMonthViewDelegate, JTACMonthViewDataSource {

    // MARK: - Outlets

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        if let customButton = self.appearance.customCancelButton {
            customButton.target = self
            customButton.action = #selector(self.cancel)
            return customButton
        }

        let barButtonItem = UIBarButtonItem(title: self.appearance.cancelButtonTitle, style: .plain, target: self, action: #selector(self.cancel))
        barButtonItem.tintColor = self.appearance.barButtonItemsColor
        return barButtonItem
    }()

    private lazy var doneBarButtonItem: UIBarButtonItem = {
        if let customButton = self.appearance.customDoneButton {
            customButton.target = self
            customButton.action = #selector(self.done)
            return customButton
        }

        let barButtonItem = UIBarButtonItem(title: self.appearance.doneButtonTitle, style: .done, target: self, action: #selector(self.done))
        barButtonItem.tintColor = self.appearance.barButtonItemsColor
        barButtonItem.isEnabled = self.allowToChooseNilDate
        return barButtonItem
    }()

    private lazy var calendarView: JTACMonthView = {
        let monthView = JTACMonthView()
        monthView.backgroundColor = self.appearance.backgroundColor
        monthView.ibCalendarDelegate = self
        monthView.ibCalendarDataSource = self
        monthView.minimumLineSpacing = 2
        monthView.minimumInteritemSpacing = 0
        monthView.showsVerticalScrollIndicator = false
        monthView.cellSize = 46
        monthView.allowsMultipleSelection = Value.mode == .range
        monthView.allowsRangedSelection = true
        monthView.rangeSelectionMode = .continuous
        monthView.contentInsetAdjustmentBehavior = .always
        return monthView
    }()

    private lazy var weekView: WeekView = {
        return WeekView(config: self.config.weekView)
    }()

    private lazy var currentValueView: CurrentValueView<Value> = {
        let view = CurrentValueView<Value>(config: self.config.currentValueView)
        view.currentValue = self.value
        view.onClear = {
            self.value = nil
            self.viewConfigs.removeAll()
            self.calendarView.deselectAllDates()
            self.calendarView.visibleDates { (segment) in
                UIView.performWithoutAnimation {
                    self.calendarView.reloadItems(at: (segment.outdates + segment.indates).map({ $0.indexPath }))
                }
            }
        }
        return view
    }()

    private lazy var shortcutContainerView: ShortcutContainerView<Value> = {
        let view = ShortcutContainerView<Value>(config: self.config.shortcutContainerView, itemConfig: self.config.shortcutItemView, shortcuts: self.shortcuts)
        if let value = self.value {
            view.selectedShortcut = self.shortcuts.first(where: { $0.isEqual(to: value) })
        }
        view.onSelect = { selectedShortcut in
            let newValue = selectedShortcut.action()
            if !newValue.outOfRange(minDate: self.privateMinimumDate, maxDate: self.privateMaximumDate) {
                self.value = newValue
                self.selectValue(newValue, in: self.calendarView)
            }
        }
        return view
    }()

    // MARK: - Variables

    private let config: FastisConfig
    private var appearance: FastisConfig.Controller = FastisConfig.default.controller
    private let dayCellReuseIdentifier = "DayCellReuseIdentifier"
    private let monthHeaderReuseIdentifier = "MonthHeaderReuseIdentifier"
    private var viewConfigs: [IndexPath: DayCell.ViewConfig] = [:]
    private var currentCalendar: Calendar = .autoupdatingCurrent
    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?
    private var privateSelectMonthOnHeaderTap: Bool = false
    private var value: Value? {
        didSet {
            self.updateSelectedShortcut()
            self.currentValueView.currentValue = self.value
            self.doneBarButtonItem.isEnabled = self.allowToChooseNilDate || self.value != nil
        }
    }

    /**
     Shortcuts array
     
     You can use prepered shortcuts depending on the current mode.
     
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
     Allow to choose `nil` date
     
     If you set `true` done button will be wlways enabled
     */
    public var allowToChooseNilDate: Bool = false

    /**
     The block to execute after the dismissal finishes
     */
    public var dismissHandler: (() -> Void)?

    /**
    The block to execute after "Done" button will be tapped
    */
    public var doneHandler: ((Value?) -> Void)?

    /**
     And initial value which will be selected bu default
     */
    public var initialValue: Value?

    /**
     Minimal selection date. Dates less then current will be markes as unavailable
     */
    public var minimumDate: Date? {
        get {
            return self.privateMinimumDate
        }
        set {
            self.privateMinimumDate = newValue?.startOfDay()
        }
    }

    /**
     Allow date range changes
     
     Set this variable to `false` if you want to disable date range changes.
     Next tap after selecting range will start new range selection.
     */
    public var allowDateRangeChanges: Bool = true

    /**
    Maximum selection date. Dates greather then current will be markes as unavailable
    */
    public var maximumDate: Date? {
        get {
            return self.privateMaximumDate
        }
        set {
            self.privateMaximumDate = newValue?.endOfDay()
        }
    }

    // MARK: - Lifecycle

    public init(config: FastisConfig = .default) {
        self.config = config
        self.appearance = config.controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureSubviews()
        self.configureConstraints()
        self.configureInitialState()
    }

    /**
     Present FastisController above current top view controller
     
     - Parameters:
        - viewController: view controller which will present FastisController
        - flag: Pass true to animate the presentation; otherwise, pass false.
        - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
     
     */
    public func present(above viewController: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        let navVc = UINavigationController(rootViewController: self)
        navVc.modalTransitionStyle = viewController.modalTransitionStyle
        navVc.transitioningDelegate = viewController.transitioningDelegate
        navVc.isModalInPresentation = viewController.isModalInPresentation
        navVc.modalPresentationStyle = .formSheet
        if viewController.preferredContentSize != .zero {
            navVc.preferredContentSize = viewController.preferredContentSize
        } else {
            navVc.preferredContentSize = CGSize(width: 445, height: 550)
        }

        viewController.present(navVc, animated: flag, completion: completion)
    }

    // MARK: - Configuration

    private func configureUI() {
        self.view.backgroundColor = self.appearance.backgroundColor
        self.navigationController?.navigationBar.titleTextAttributes = self.appearance.titleTextAttributes

        let appearnce = UINavigationBarAppearance()
        appearnce.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = appearnce
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem

    }

    private func configureSubviews() {
        self.calendarView.register(DayCell.self, forCellWithReuseIdentifier: self.dayCellReuseIdentifier)
        self.calendarView.register(MonthHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.monthHeaderReuseIdentifier)
        self.view.addSubview(self.currentValueView)
        self.view.addSubview(self.weekView)
        self.view.addSubview(self.calendarView)
        if !self.shortcuts.isEmpty {
            self.view.addSubview(self.shortcutContainerView)
        }
    }

    private func configureConstraints() {
        self.currentValueView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.safeAreaLayoutGuide)
            maker.left.right.equalToSuperview().inset(12)
        }
        self.weekView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.currentValueView.snp.bottom)
            maker.left.right.equalToSuperview().inset(12)
        }
        if !self.shortcuts.isEmpty {
            self.shortcutContainerView.snp.makeConstraints { (maker) in
                maker.bottom.left.right.equalToSuperview()
            }
        }
        self.calendarView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.weekView.snp.bottom)
            maker.left.right.equalToSuperview().inset(16)
            if !self.shortcuts.isEmpty {
                maker.bottom.equalTo(self.shortcutContainerView.snp.top)
            } else {
                maker.bottom.equalToSuperview()
            }
        }
    }

    private func configureInitialState() {
        self.value = self.initialValue
        if let date = self.value as? Date {
            self.calendarView.selectDates([date])
            self.calendarView.scrollToHeaderForDate(date)
        } else if let rangeValue = self.value as? FastisRange {
            self.selectRange(rangeValue, in: self.calendarView)
            self.calendarView.scrollToHeaderForDate(rangeValue.fromDate)
        } else {
            let nowDate = Date()
            let targetDate = self.privateMaximumDate ?? nowDate
            if targetDate < nowDate {
                self.calendarView.scrollToHeaderForDate(targetDate)
            } else {
                self.calendarView.scrollToHeaderForDate(Date())
            }
        }
    }

    private func configureCell(_ cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DayCell else { return }
        if let cachedConfig = self.viewConfigs[indexPath] {
            cell.configure(for: cachedConfig)
        } else {
            let newConfig = DayCell.makeViewConfig(for: cellState,
                                                   minimumDate: self.privateMinimumDate,
                                                   maximumDate: self.privateMaximumDate,
                                                   rangeValue: self.value as? FastisRange)
            self.viewConfigs[indexPath] = newConfig
            cell.applyConfig(self.config.dayCell)
            cell.configure(for: newConfig)
        }
    }

    // MARK: - Actions

    private func updateSelectedShortcut() {
        guard !self.shortcuts.isEmpty else { return }
        if let value = self.value {
            self.shortcutContainerView.selectedShortcut = self.shortcuts.first(where: { $0.isEqual(to: value) })
        } else {
            self.shortcutContainerView.selectedShortcut = nil
        }
    }

    @objc private func cancel() {
        self.navigationController?.dismiss(animated: true, completion: {
            self.dismissHandler?()
        })
    }

    @objc private func done() {
        self.doneHandler?(self.value)
        self.cancel()
    }

    private func selectValue(_ value: Value?, in calendar: JTACMonthView) {
        if let date = value as? Date {
            calendar.selectDates([date])
        } else if let range = value as? FastisRange {
            self.selectRange(range, in: calendar)
        }
    }

    private func handleDateTap(in calendar: JTACMonthView, date: Date) {

        switch Value.mode {
        case .single:
            self.value = date as? Value
            self.selectValue(date as? Value, in: calendar)
            return

        case .range:
            var newValue: FastisRange!
            if let currentValue = self.value as? FastisRange {

                let dateRangeChangesDisabled = !allowDateRangeChanges
                let rangeSelected = !currentValue.fromDate.isInSameDay(date: currentValue.toDate)
                if dateRangeChangesDisabled && rangeSelected {
                    newValue = .from(date.startOfDay(in: self.currentCalendar), to: date.endOfDay(in: self.currentCalendar))
                } else if date.isInSameDay(in: self.currentCalendar, date: currentValue.fromDate) {
                    let newToDate = date.endOfDay(in: self.currentCalendar)
                    newValue = .from(currentValue.fromDate, to: newToDate)
                } else if date.isInSameDay(in: self.currentCalendar, date: currentValue.toDate) {
                    let newFromDate = date.startOfDay(in: self.currentCalendar)
                    newValue = .from(newFromDate, to: currentValue.toDate)
                } else if date < currentValue.fromDate {
                    let newFromDate = date.startOfDay(in: self.currentCalendar)
                    newValue = .from(newFromDate, to: currentValue.toDate)
                } else {
                    let newToDate = date.endOfDay(in: self.currentCalendar)
                    newValue = .from(currentValue.fromDate, to: newToDate)
                }

            } else {
                newValue = .from(date.startOfDay(in: self.currentCalendar), to: date.endOfDay(in: self.currentCalendar))
            }

            self.value = newValue as? Value
            self.selectValue(newValue as? Value, in: calendar)

        }

    }

    private func selectRange(_ range: FastisRange, in calendar: JTACMonthView) {
        calendar.deselectAllDates(triggerSelectionDelegate: false)
        calendar.selectDates(from: range.fromDate, to: range.toDate, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        calendar.visibleDates { (segment) in
            UIView.performWithoutAnimation {
                calendar.reloadItems(at: (segment.outdates + segment.indates).map({ $0.indexPath }))
            }
        }
    }

    // MARK: - JTACMonthViewDelegate

    public func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = self.currentCalendar.timeZone
        dateFormatter.locale = self.currentCalendar.locale
        var startDate = dateFormatter.date(from: "2000 01 01")!
        var endDate = dateFormatter.date(from: "2030 12 01")!

        if let maximumDate = self.privateMaximumDate,
            let endOfNextMonth = self.currentCalendar.date(byAdding: .month, value: 2, to: maximumDate)?
                .endOfMonth(in: self.currentCalendar) {
            endDate = endOfNextMonth
        }

        if let minimumDate = self.privateMinimumDate,
            let startOfPreviousMonth = self.currentCalendar.date(byAdding: .month, value: -2, to: minimumDate)?
                .startOfMonth(in: self.currentCalendar) {
            startDate = startOfPreviousMonth
        }

        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: self.currentCalendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .monday,
                                                 hasStrictBoundaries: true)
        return parameters
    }

    public func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: self.monthHeaderReuseIdentifier, for: indexPath) as! MonthHeader
        header.applyConfig(self.config.monthHeader)
        header.configure(for: range.start)
        if self.privateSelectMonthOnHeaderTap, Value.mode == .range {
            header.tapHandler = {
                var fromDate = range.start.startOfMonth(in: self.currentCalendar)
                var toDate = range.start.endOfMonth(in: self.currentCalendar)
                if let minDate = self.minimumDate {
                    if toDate < minDate { return } else if fromDate < minDate {
                        fromDate = minDate.startOfDay(in: self.currentCalendar)
                    }
                }
                if let maxDate = self.maximumDate {
                    if fromDate > maxDate { return } else if toDate > maxDate {
                        toDate = maxDate.endOfDay(in: self.currentCalendar)
                    }
                }
                let newValue: FastisRange = .from(fromDate, to: toDate)
                self.value = newValue as? Value
                self.selectRange(newValue, in: calendar)
            }
        }
        return header
    }

    public func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: self.dayCellReuseIdentifier, for: indexPath)
        self.configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    public func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        self.configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
    }

    public func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) {
            self.handleDateTap(in: calendar, date: date)
        } else if let cell = cell {
            self.configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        }
    }

    public func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) && Value.mode == .range {
            self.handleDateTap(in: calendar, date: date)
        } else if let cell = cell {
            self.configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        }
    }

    public func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        self.viewConfigs.removeAll()
        return true
    }

    public func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        self.viewConfigs.removeAll()
        return true
    }

    public func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return self.config.monthHeader.size
    }

}

extension FastisController where Value == FastisRange {

    /// Initiate FastisController
    /// - Parameters:
    ///   - mode: Choose `.range` or `.single` mode
    ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    public convenience init(mode: FastisModeRange, config: FastisConfig = .default) {
        self.init(config: config)
        self.selectMonthOnHeaderTap = true
    }

    /**
     Set this variable to `true` if you want to allow select date ranges by tapping on months
     */
    public var selectMonthOnHeaderTap: Bool {
        get {
            return self.privateSelectMonthOnHeaderTap
        }
        set {
            self.privateSelectMonthOnHeaderTap = newValue
        }
    }
}

extension FastisController where Value == Date {

    /// Initiate FastisController
    /// - Parameters:
    ///   - mode: Choose .range or .single mode
    ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    public convenience init(mode: FastisModeSingle, config: FastisConfig = .default) {
        self.init(config: config)
    }

}

extension FastisConfig {
    public struct Controller {
        public var cancelButtonTitle: String = "Cancel"
        public var doneButtonTitle: String = "Done"
        public var titleTextAttributes: [NSAttributedString.Key: Any] = [:]
        public var backgroundColor: UIColor = .white
        public var barButtonItemsColor: UIColor = .systemBlue
        public var customCancelButton: UIBarButtonItem?
        public var customDoneButton: UIBarButtonItem?
    }
}
