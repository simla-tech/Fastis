//
//  FastisMonthHeader.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import JTAppleCalendar
import UIKit

final class MonthHeader: JTACMonthReusableView {

    // MARK: - Outlets

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "Month name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Variables

    private var leftAnchorConstraint: NSLayoutConstraint?
    private var rightAnchorConstraint: NSLayoutConstraint?
    private var topAnchorConstraint: NSLayoutConstraint?
    private var bottomAnchorConstraint: NSLayoutConstraint?

    internal var calculatedHeight: CGFloat = 0
    internal var tapHandler: (() -> Void)?
    private lazy var monthFormatter = DateFormatter()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.configureConstraints()
        self.applyConfig(FastisConfig.default.monthHeader)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.addGestureRecognizer(tapRecognizer)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureSubviews() {
        self.addSubview(self.monthLabel)
    }

    private func configureConstraints() {
        self.leftAnchorConstraint = self.monthLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        self.rightAnchorConstraint = self.monthLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        self.topAnchorConstraint = self.monthLabel.topAnchor.constraint(equalTo: self.topAnchor)
        self.bottomAnchorConstraint = self.monthLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([
            self.leftAnchorConstraint, self.rightAnchorConstraint, self.topAnchorConstraint, self.bottomAnchorConstraint
        ].compactMap({ $0 }))
    }

    internal func configure(for date: Date) {
        self.monthLabel.text = self.monthFormatter.string(from: date).capitalizingFirstLetter()
    }

    // MARK: - Actions

    internal func applyConfig(_ config: FastisConfig.MonthHeader) {
        self.monthFormatter.dateFormat = config.monthFormat
        self.monthFormatter.locale = config.monthLocale
        self.monthLabel.font = config.labelFont
        self.monthLabel.textColor = config.labelColor
        self.monthLabel.textAlignment = config.labelAlignment
        self.leftAnchorConstraint?.constant = config.insets.left
        self.rightAnchorConstraint?.constant = -config.insets.right
        self.topAnchorConstraint?.constant = config.insets.top
        self.bottomAnchorConstraint?.constant = -config.insets.bottom
    }

    @objc
    private func viewTapped() {
        self.tapHandler?()
    }

}

public extension FastisConfig {

    /**
     Month titles

     Configurable in FastisConfig.``FastisConfig/monthHeader-swift.property`` property
     */
    struct MonthHeader {

        /**
         Text alignment for month title label

         Default value — `.left`
         */
        public var labelAlignment: NSTextAlignment = .left

        /**
         Text color for month title label

         Default value — `.label`
         */
        public var labelColor: UIColor = .label

        /**
         Text font for month title label

         Default value — `.systemFont(ofSize: 17, weight: .semibold)`
         */
        public var labelFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)

        /**
         Insets for month title label

         Default value — `UIEdgeInsets(top: 24, left: 8, bottom: 4, right: 16)`
         */
        public var insets = UIEdgeInsets(top: 24, left: 8, bottom: 4, right: 16)

        /**
         Format of displayed month value

         Default value — `"LLLL yyyy"`
         */
        public var monthFormat = "LLLL yyyy"

        /**
         Locale of displayed month value

         Default value — `.current`
         */
        public var monthLocale: Locale = .current

        /**
         Height of month view

         Default value — `48pt`
         */
        public var height = MonthSize(defaultSize: 48)
    }

}
