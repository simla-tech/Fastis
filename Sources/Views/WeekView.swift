//
//  FastisWeekView.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import SnapKit

class WeekView: UIView {

    // MARK: - Outlets

    public lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Variables

    private let config: FastisConfig.WeekView

    // MARK: - Lifecycle

    init(config: FastisConfig.WeekView) {
        self.config = config
        super.init(frame: .zero)
        self.configureUI()
        self.configureSubviews()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureUI() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
    }

    private func configureSubviews() {
        var weekDays = self.config.calendar.shortWeekdaySymbols
        weekDays.append(weekDays.remove(at: 0))
        for weekdaySymbol in weekDays {
            self.stackView.addArrangedSubview(self.makeWeekLabel(for: weekdaySymbol))
        }
        self.addSubview(self.stackView)
    }

    func makeWeekLabel(for simbol: String) -> UILabel {
        let label = UILabel()
        label.text = self.config.uppercaseWeekName ? simbol.uppercased() : simbol
        label.font = self.config.textFont
        label.textColor = self.config.textColor
        label.textAlignment = .center
        return label
    }

    private func configureConstraints() {
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.right.equalToSuperview().inset(4)
        }
        self.snp.makeConstraints { (maker) in
            maker.height.equalTo(self.config.height)
        }
    }

}

extension FastisConfig {

    /**
     Top header view with week day names

     Configurable in FastisConfig.``FastisConfig/weekView-swift.property`` property
     */
    public struct WeekView {

        /**
         Calendar which is used to get a `.shortWeekdaySymbols`
         
         Default value — `.current`
         */
        public var calendar: Calendar = .current

        /**
         Background color of the view
         
         Default value — `.secondarySystemBackground`
         */
        public var backgroundColor: UIColor = .secondarySystemBackground

        /**
         Text color of labels
         
         Default value — `.secondaryLabel`
         */
        public var textColor: UIColor = .secondaryLabel

        /**
         Text font of labels
         
         Default value — `.systemFont(ofSize: 10, weight: .bold)`
         */
        public var textFont: UIFont = .systemFont(ofSize: 10, weight: .bold)

        /**
         Height of the view
         
         Default value — `28pt`
         */
        public var height: CGFloat = 28

        /**
         Corner radius of the view
         
         Default value — `8pt`
         */
        public var cornerRadius: CGFloat = 8

        /**
         Make week names uppercased
         
         Default value — `true`
         */
        public var uppercaseWeekName: Bool = true

    }
}
