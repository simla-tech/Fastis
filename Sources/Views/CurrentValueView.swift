//
//  FastisCurrentValueView.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import SnapKit

class CurrentValueView<Value: FastisValue>: UIView {

    // MARK: - Outlets

    public lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = self.config.placeholderedTextColor
        label.text = self.config.placeholderTextForRanges
        label.font = self.config.textFont
        return label
    }()

    public lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
        button.setImage(self.config.clearButtonImage, for: .normal)
        button.tintColor = self.config.clearButtonTintColor
        button.alpha = 0
        button.isUserInteractionEnabled = false
        return button
    }()

    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Variables

    private let config: FastisConfig.CurrentValueView
    public var onClear: (() -> Void)?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = self.config.locale
        formatter.dateFormat = self.config.format
        return formatter
    }()

    public var currentValue: Value? {
        didSet {
            self.updateStateForCurrentValue()
        }
    }

    // MARK: - Lifecycle

    init(config: FastisConfig.CurrentValueView) {
        self.config = config
        super.init(frame: .zero)
        self.configureUI()
        self.configureSubviews()
        self.configureConstaints()
        self.updateStateForCurrentValue()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureUI() {
        self.backgroundColor = .clear
    }

    private func configureSubviews() {
        self.containerView.addSubview(self.label)
        self.containerView.addSubview(self.clearButton)
        self.addSubview(self.containerView)
    }

    private func configureConstaints() {
        self.clearButton.snp.makeConstraints { (maker) in
            maker.right.top.bottom.centerY.equalToSuperview()
        }
        self.label.snp.makeConstraints { (maker) in
            maker.top.bottom.centerX.equalToSuperview()
            maker.right.lessThanOrEqualTo(self.clearButton.snp.left)
            maker.left.greaterThanOrEqualToSuperview()
        }
        self.containerView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(self.config.insets)
        }
    }

    private func updateStateForCurrentValue() {

        if let value = self.currentValue as? Date {

            self.label.text = self.dateFormatter.string(from: value)
            self.label.textColor = self.config.textColor
            self.clearButton.alpha = 1
            self.clearButton.isUserInteractionEnabled = true

        } else if let value = self.currentValue as? FastisRange {

            self.label.textColor = self.config.textColor
            self.clearButton.alpha = 1
            self.clearButton.isUserInteractionEnabled = true

            if value.onSameDay {
                self.label.text = self.dateFormatter.string(from: value.fromDate)
            } else {
                self.label.text = self.dateFormatter.string(from: value.fromDate) + " – " + self.dateFormatter.string(from: value.toDate)
            }

        } else {

            self.label.textColor = self.config.placeholderedTextColor
            self.clearButton.alpha = 0
            self.clearButton.isUserInteractionEnabled = false

            switch Value.mode {
            case .range:
                self.label.text = self.config.placeholderTextForRanges

            case .single:
                self.label.text = self.config.placeholderTextForSingle

            }

        }

    }

    // MARK: - Actions

    @objc func clear() {
        self.onClear?()
    }

}

extension FastisConfig {
    public struct CurrentValueView {
        public var placeholderTextForRanges: String = "Select date range"
        public var placeholderTextForSingle: String = "Select date"
        public var placeholderedTextColor: UIColor = .lightGray
        public var textColor: UIColor = .black
        public var textFont: UIFont = .systemFont(ofSize: 17, weight: .regular)
        public var clearButtonImage: UIImage = UIImage(asset: FastisAsset.iconClear)!
        public var clearButtonTintColor: UIColor = .darkGray
        public var insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        public var format: String = "d MMMM"
        public var locale: Locale = .autoupdatingCurrent
    }
}
