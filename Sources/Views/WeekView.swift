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
        self.configureConstaints()
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
        for weekdaySimbol in weekDays {
            self.stackView.addArrangedSubview(self.makeWeekLabel(for: weekdaySimbol))
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

    private func configureConstaints() {
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
    public struct WeekView {
        public var calendar: Calendar = .current
        public var backgroundColor: UIColor = .white
        public var textColor: UIColor = .darkGray
        public var textFont: UIFont = .systemFont(ofSize: 10, weight: .bold)
        public var height: CGFloat = 28
        public var cornerRadius: CGFloat = 8
        public var uppercaseWeekName: Bool = true
    }
}
