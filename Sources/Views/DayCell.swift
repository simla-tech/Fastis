//
//  FastisDayCell.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

class DayCell: JTACDayCell {

    // MARK: - Outlets

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        return label
    }()

    lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    lazy var rangedBackgroundViewRoundedLeft: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.isHidden = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.layer.cornerCurve = .continuous
        return view
    }()

    lazy var rangedBackgroundViewRoundedRight: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.isHidden = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerCurve = .continuous
        return view
    }()

    lazy var rangedBackgroundViewSquaredLeft: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    lazy var rangedBackgroundViewSquaredRight: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    // MARK: - Variables

    private var config: FastisConfig.DayCell = FastisConfig.default.dayCell
    private var rangedBackgroundViewTopBottomConstraints: [Constraint] = []

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.configureConstraints()
        self.applyConfig(.default)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurations

    public func applyConfig(_ config: FastisConfig) {
        self.backgroundColor = config.controller.backgroundColor

        let config = config.dayCell
        self.config = config
        self.rangedBackgroundViewSquaredRight.backgroundColor = config.onRangeBackgroundColor
        self.rangedBackgroundViewSquaredLeft.backgroundColor = config.onRangeBackgroundColor
        self.rangedBackgroundViewRoundedRight.backgroundColor = config.onRangeBackgroundColor
        self.rangedBackgroundViewRoundedLeft.backgroundColor = config.onRangeBackgroundColor
        self.rangedBackgroundViewRoundedRight.layer.cornerRadius = config.rangeViewCornerRadius
        self.rangedBackgroundViewRoundedLeft.layer.cornerRadius = config.rangeViewCornerRadius
        self.selectionBackgroundView.backgroundColor = config.selectedBackgroundColor
        self.dateLabel.font = config.dateLabelFont
        self.dateLabel.textColor = config.dateLabelColor
        if let cornerRadius = config.customSelectionViewCornerRadius {
             self.selectionBackgroundView.layer.cornerRadius = cornerRadius
        }
        self.rangedBackgroundViewTopBottomConstraints.forEach({
            $0.update(inset: config.rangedBackgroundViewVerticalInset)
        })
    }

    public func configureSubviews() {
        self.contentView.addSubview(self.rangedBackgroundViewRoundedLeft)
        self.contentView.addSubview(self.rangedBackgroundViewSquaredLeft)
        self.contentView.addSubview(self.rangedBackgroundViewRoundedRight)
        self.contentView.addSubview(self.rangedBackgroundViewSquaredRight)
        self.contentView.addSubview(self.selectionBackgroundView)
        self.contentView.addSubview(self.dateLabel)
        self.selectionBackgroundView.layer.cornerRadius = .minimum(self.frame.width, self.frame.height) / 2
    }

    public func configureConstraints() {
        let inset = config.rangedBackgroundViewVerticalInset
        self.rangedBackgroundViewRoundedLeft.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            rangedBackgroundViewTopBottomConstraints.append(maker.bottom.top.equalToSuperview().inset(inset).constraint)
            maker.right.equalTo(self.contentView.snp.centerX)
        }
        self.rangedBackgroundViewSquaredLeft.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            rangedBackgroundViewTopBottomConstraints.append(maker.bottom.top.equalToSuperview().inset(inset).constraint)
            maker.right.equalTo(self.contentView.snp.centerX)
        }
        self.rangedBackgroundViewRoundedRight.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview()
            rangedBackgroundViewTopBottomConstraints.append(maker.bottom.top.equalToSuperview().inset(inset).constraint)
            maker.left.equalTo(self.contentView.snp.centerX)
        }
        self.rangedBackgroundViewSquaredRight.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(1) // Add small offset to prevent spacing between cells
            rangedBackgroundViewTopBottomConstraints.append(maker.bottom.top.equalToSuperview().inset(inset).constraint)
            maker.left.equalTo(self.contentView.snp.centerX)
        }
        self.selectionBackgroundView.snp.makeConstraints { (maker) in
            maker.height.equalTo(100).priority(.low)
            maker.top.left.greaterThanOrEqualToSuperview().offset(1)
            maker.right.bottom.lessThanOrEqualToSuperview().offset(-1)
            maker.center.equalToSuperview()
            maker.width.equalTo(self.selectionBackgroundView.snp.height)
        }
        self.dateLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    public static func makeViewConfig(for state: CellState, minimumDate: Date?, maximumDate: Date?, rangeValue: FastisRange?) -> ViewConfig {

        var config = ViewConfig()

        if state.dateBelongsTo != .thisMonth {

            config.isSelectedViewHidden = true

            if let value = rangeValue {

                let calendar = Calendar.current
                var showRangeView: Bool = false

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

                    if state.day == .monday {
                        config.rangeView.roundedLeftHidden = false
                        config.rangeView.squaredRightHidden = false
                    } else if state.day == .sunday {
                        config.rangeView.squaredLeftHidden = false
                        config.rangeView.roundedRightHidden = false
                    } else {
                        config.rangeView.squaredLeftHidden = false
                        config.rangeView.squaredRightHidden = false
                    }
                }

            }

            return config
        }

        config.dateLabelText = state.text

        if let minimumDate = minimumDate, state.date < minimumDate.startOfDay() {
            config.isDateEnabled = false
            return config
        } else if let maximumDate = maximumDate, state.date > maximumDate.endOfDay() {
            config.isDateEnabled = false
            return config
        }

        if state.isSelected {

            let position = state.selectedPosition()

            switch position {

            case .full:
                config.isSelectedViewHidden = false

            case .left, .right, .middle:
                config.isSelectedViewHidden = position == .middle

                if position == .right && state.day == .monday {
                    config.rangeView.roundedLeftHidden = false

                } else if position == .left && state.day == .sunday {
                    config.rangeView.roundedRightHidden = false

                } else if position == .left {
                    config.rangeView.squaredRightHidden = false

                } else if position == .right {
                    config.rangeView.squaredLeftHidden = false

                } else if state.day == .monday {
                    config.rangeView.squaredRightHidden = false
                    config.rangeView.roundedLeftHidden = false

                } else if state.day == .sunday {
                    config.rangeView.squaredLeftHidden = false
                    config.rangeView.roundedRightHidden = false

                } else {
                    config.rangeView.squaredLeftHidden = false
                    config.rangeView.squaredRightHidden = false
                }

            default:
                break
            }

        }

        return config
    }

    enum RangeViewTrimState {
        case trimLeftHalf
        case trimRightHalf
    }

    enum RangeViewRoundState {
        case leftCorners
        case rightCorners
    }

    struct RangeViewConfig: Hashable {

        var roundedLeftHidden: Bool = true
        var roundedRightHidden: Bool = true
        var squaredLeftHidden: Bool = true
        var squaredRightHidden: Bool = true

        var isHidden: Bool {
            return self.roundedLeftHidden && self.roundedRightHidden && self.squaredLeftHidden && self.squaredRightHidden
        }

    }

    struct ViewConfig {
        var dateLabelText: String?
        var isSelectedViewHidden: Bool = true
        var isDateEnabled: Bool = true
        var rangeView: RangeViewConfig = RangeViewConfig()
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

        self.rangedBackgroundViewRoundedLeft.isHidden = config.rangeView.roundedLeftHidden
        self.rangedBackgroundViewSquaredLeft.isHidden = config.rangeView.squaredLeftHidden
        self.rangedBackgroundViewRoundedRight.isHidden = config.rangeView.roundedRightHidden
        self.rangedBackgroundViewSquaredRight.isHidden = config.rangeView.squaredRightHidden

    }

}

extension FastisConfig {

    /**
     Day cells (selection parameters, font, etc.)
     
     Configurable in FastisConfig.``FastisConfig/dayCell-swift.property`` property
     */
    public struct DayCell {

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
