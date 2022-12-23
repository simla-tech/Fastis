//
//  FastisDayCell.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import JTAppleCalendar
import UIKit

final class DayCell: JTACDayCell {

    // MARK: - Outlets

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var leftRangeView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var rightRangeView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Variables

    private var config: FastisConfig.DayCell = FastisConfig.default.dayCell
    private var rangeViewTopAnchorConstraints: [NSLayoutConstraint] = []
    private var rangeViewBottomAnchorConstraints: [NSLayoutConstraint] = []

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.configureConstraints()
        self.applyConfig(.default)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurations

    public func applyConfig(_ config: FastisConfig) {
        self.backgroundColor = config.controller.backgroundColor

        let config = config.dayCell
        self.config = config
        self.rightRangeView.backgroundColor = config.onRangeBackgroundColor
        self.leftRangeView.backgroundColor = config.onRangeBackgroundColor
        self.rightRangeView.layer.cornerRadius = config.rangeViewCornerRadius
        self.leftRangeView.layer.cornerRadius = config.rangeViewCornerRadius
        self.selectionBackgroundView.backgroundColor = config.selectedBackgroundColor
        self.dateLabel.font = config.dateLabelFont
        self.dateLabel.textColor = config.dateLabelColor
        if let cornerRadius = config.customSelectionViewCornerRadius {
            self.selectionBackgroundView.layer.cornerRadius = cornerRadius
        }
        self.rangeViewTopAnchorConstraints.forEach({ $0.constant = config.rangedBackgroundViewVerticalInset })
        self.rangeViewBottomAnchorConstraints.forEach({ $0.constant = -config.rangedBackgroundViewVerticalInset })
    }

    public func configureSubviews() {
        self.contentView.addSubview(self.leftRangeView)
        self.contentView.addSubview(self.rightRangeView)
        self.contentView.addSubview(self.selectionBackgroundView)
        self.contentView.addSubview(self.dateLabel)
        self.selectionBackgroundView.layer.cornerRadius = .minimum(self.frame.width, self.frame.height) / 2
    }

    public func configureConstraints() {
        let inset = self.config.rangedBackgroundViewVerticalInset
        NSLayoutConstraint.activate([
            self.dateLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            self.leftRangeView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.leftRangeView.rightAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            self.rightRangeView.leftAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            // Add small offset to prevent spacing between cells
            self.rightRangeView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 1)
        ])
        NSLayoutConstraint.activate([
            {
                let constraint = self.selectionBackgroundView.heightAnchor.constraint(equalToConstant: 100)
                constraint.priority = .defaultLow
                return constraint
            }(),
            self.selectionBackgroundView.leftAnchor.constraint(greaterThanOrEqualTo: self.contentView.leftAnchor, constant: 1),
            self.selectionBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 1),
            self.selectionBackgroundView.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -1),
            self.selectionBackgroundView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -1),
            self.selectionBackgroundView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.selectionBackgroundView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.selectionBackgroundView.widthAnchor.constraint(equalTo: self.selectionBackgroundView.heightAnchor)
        ])
        self.rangeViewTopAnchorConstraints = [
            self.leftRangeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: inset),
            self.rightRangeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: inset)
        ]
        self.rangeViewBottomAnchorConstraints = [
            self.leftRangeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -inset),
            self.rightRangeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -inset)
        ]
        NSLayoutConstraint.activate(self.rangeViewTopAnchorConstraints)
        NSLayoutConstraint.activate(self.rangeViewBottomAnchorConstraints)
    }

    public static func makeViewConfig(
        for state: CellState,
        minimumDate: Date?,
        maximumDate: Date?,
        rangeValue: FastisRange?,
        calendar: Calendar
    ) -> ViewConfig {

        var config = ViewConfig()

        if state.dateBelongsTo != .thisMonth {

            config.isSelectedViewHidden = true

            if let value = rangeValue {

                let calendar = Calendar.current
                var showRangeView = false

                if state.dateBelongsTo == .followingMonthWithinBoundary {
                    let endOfPreviousMonth = calendar.date(byAdding: .month, value: -1, to: state.date)!.endOfMonth(in: calendar)
                    let startOfCurrentMonth = state.date.startOfMonth(in: calendar)
                    let fromDateIsInPast = value.fromDate < endOfPreviousMonth
                    let toDateIsInFutureOrCurrent = value.toDate > startOfCurrentMonth
                    showRangeView = fromDateIsInPast && toDateIsInFutureOrCurrent
                } else if state.dateBelongsTo == .previousMonthWithinBoundary {
                    let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: state.date)!.startOfMonth(in: calendar)
                    let endOfCurrentMonth = state.date.endOfMonth(in: calendar)
                    let toDateIsInFuture = value.toDate > startOfNextMonth
                    let fromDateIsInPastOrCurrent = value.fromDate < endOfCurrentMonth
                    showRangeView = toDateIsInFuture && fromDateIsInPastOrCurrent
                }

                if showRangeView {

                    if state.day.rawValue == calendar.firstWeekday {
                        config.rangeView.leftSideState = .rounded
                        config.rangeView.rightSideState = .squared
                    } else if state.day.rawValue == calendar.lastWeekday {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .rounded
                    } else {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .squared
                    }
                }

            }

            return config
        }

        config.dateLabelText = state.text

        if let minimumDate, state.date < minimumDate.startOfDay() {
            config.isDateEnabled = false
            return config
        } else if let maximumDate, state.date > maximumDate.endOfDay() {
            config.isDateEnabled = false
            return config
        }

        if state.isSelected {

            let position = state.selectedPosition()

            switch position {

            case .full:
                config.isSelectedViewHidden = false

            case .left,
                 .right,
                 .middle:
                config.isSelectedViewHidden = position == .middle

                if position == .right, state.day.rawValue == calendar.firstWeekday {
                    config.rangeView.leftSideState = .rounded

                } else if position == .left, state.day.rawValue == calendar.lastWeekday {
                    config.rangeView.rightSideState = .rounded

                } else if position == .left {
                    config.rangeView.rightSideState = .squared

                } else if position == .right {
                    config.rangeView.leftSideState = .squared

                } else if state.day.rawValue == calendar.firstWeekday {
                    config.rangeView.leftSideState = .rounded
                    config.rangeView.rightSideState = .squared

                } else if state.day.rawValue == calendar.lastWeekday {
                    config.rangeView.leftSideState = .squared
                    config.rangeView.rightSideState = .rounded

                } else {
                    config.rangeView.leftSideState = .squared
                    config.rangeView.rightSideState = .squared
                }

            default:
                break
            }

        }

        return config
    }

    enum RangeSideState {
        case squared
        case rounded
        case hidden
    }

    struct RangeViewConfig: Hashable {

        var leftSideState: RangeSideState = .hidden
        var rightSideState: RangeSideState = .hidden

        var isHidden: Bool {
            self.leftSideState == .hidden && self.rightSideState == .hidden
        }

    }

    struct ViewConfig {
        var dateLabelText: String?
        var isSelectedViewHidden = true
        var isDateEnabled = true
        var rangeView = RangeViewConfig()
    }

    internal func configure(for config: ViewConfig) {

        self.selectionBackgroundView.isHidden = config.isSelectedViewHidden
        self.isUserInteractionEnabled = config.dateLabelText != nil && config.isDateEnabled
        self.clipsToBounds = config.dateLabelText == nil

        if let dateLabelText = config.dateLabelText {
            self.dateLabel.isHidden = false
            self.dateLabel.text = dateLabelText
            if !config.isDateEnabled {
                self.dateLabel.textColor = self.config.dateLabelUnavailableColor
            } else if !config.isSelectedViewHidden {
                self.dateLabel.textColor = self.config.selectedLabelColor
            } else if !config.rangeView.isHidden {
                self.dateLabel.textColor = self.config.onRangeLabelColor
            } else {
                self.dateLabel.textColor = self.config.dateLabelColor
            }

        } else {
            self.dateLabel.isHidden = true
        }

        switch config.rangeView.rightSideState {
        case .squared:
            self.rightRangeView.isHidden = false
            self.rightRangeView.layer.maskedCorners = []
        case .rounded:
            self.rightRangeView.isHidden = false
            self.rightRangeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .hidden:
            self.rightRangeView.isHidden = true
        }

        switch config.rangeView.leftSideState {
        case .squared:
            self.leftRangeView.isHidden = false
            self.leftRangeView.layer.maskedCorners = []
        case .rounded:
            self.leftRangeView.isHidden = false
            self.leftRangeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .hidden:
            self.leftRangeView.isHidden = true
        }

    }

}

public extension FastisConfig {

    /**
     Day cells (selection parameters, font, etc.)

     Configurable in FastisConfig.``FastisConfig/dayCell-swift.property`` property
     */
    struct DayCell {

        /**
         Font of date label in cell

         Default value — `.systemFont(ofSize: 17)`
         */
        public var dateLabelFont: UIFont = .systemFont(ofSize: 17)

        /**
         Color of date label in cell

         Default value — `.label`
         */
        public var dateLabelColor: UIColor = .label

        /**
         Color of date label in cell when date is unavailable for select

         Default value — `.tertiaryLabel`
         */
        public var dateLabelUnavailableColor: UIColor = .tertiaryLabel

        /**
         Color of background of cell when date is selected

         Default value — `.systemBlue`
         */
        public var selectedBackgroundColor: UIColor = .systemBlue

        /**
         Color of date label in cell when date is selected

         Default value — `.white`
         */
        public var selectedLabelColor: UIColor = .white

        /**
         Corner radius of cell when date is a start or end of selected range

         Default value — `6pt`
         */
        public var rangeViewCornerRadius: CGFloat = 6

        /**
         Color of background of cell when date is a part of selected range

         Default value — `.systemBlue.withAlphaComponent(0.2)`
         */
        public var onRangeBackgroundColor: UIColor = .systemBlue.withAlphaComponent(0.2)

        /**
         Color of date label in cell when date is a part of selected range

         Default value — `.label`
         */
        public var onRangeLabelColor: UIColor = .label

        /**
         Inset of cell's background view when date is a part of selected range

         Default value — `3pt`
         */
        public var rangedBackgroundViewVerticalInset: CGFloat = 3

        /**
          This property allows to set custom radius for selection view

          If this value is not `nil` then selection view will have corner radius `.height / 2`

          Default value — `nil`
         */
        public var customSelectionViewCornerRadius: CGFloat?
    }

}
