//
//  ShortcutView.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import SnapKit

class ShortcutContainerView<Value: FastisValue>: UIView {

    // MARK: - Outlets

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = self.config.itemSpacing
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Variables

    private let itemConfig: FastisConfig.ShortcutItemView
    private let config: FastisConfig.ShortcutContainerView
    internal var shortcuts: [FastisShortcut<Value>]
    internal var onSelect: ((FastisShortcut<Value>) -> Void)?

    internal var selectedShortcut: FastisShortcut<Value>? {
        didSet {
            var indexOfSelectedShortcut: Int?
            if let selectedShortcut = self.selectedShortcut {
                indexOfSelectedShortcut = self.shortcuts.firstIndex(of: selectedShortcut)
            }
            for view in self.stackView.arrangedSubviews.compactMap({ $0 as? ShortcutItemView }) {
                view.isSelected = view.tag == indexOfSelectedShortcut
            }
        }
    }

    // MARK: - Lifecycle

    init(config: FastisConfig.ShortcutContainerView, itemConfig: FastisConfig.ShortcutItemView, shortcuts: [FastisShortcut<Value>]) {
        self.config = config
        self.itemConfig = itemConfig
        self.shortcuts = shortcuts
        super.init(frame: .zero)
        self.configureUI()
        self.configureSubviews()
        self.configureConstaints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configureUI() {
        self.backgroundColor = self.config.backgroundColor
    }

    func configureSubviews() {
        self.scrollView.addSubview(self.stackView)
        self.addSubview(self.scrollView)
        for (i, item) in self.shortcuts.enumerated() {
            let itemView = ShortcutItemView(config: self.itemConfig)
            itemView.tag = i
            itemView.name = item.name
            itemView.isSelected = item == self.selectedShortcut
            itemView.tapHandler = {
                self.onSelect?(item)
            }
            self.stackView.addArrangedSubview(itemView)
        }
    }

    func configureConstaints() {
        self.stackView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview().inset(self.config.insets).priority(.high)
            maker.bottom.equalToSuperview().inset(self.config.insets).priority(.low)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.height.equalTo(self.stackView).offset(self.config.insets.top + self.config.insets.bottom)
            maker.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }

    // MARK: - Actions

}

extension FastisConfig {
    public struct ShortcutContainerView {
        public var backgroundColor: UIColor = .white
        public var itemSpacing: CGFloat = 12
        public var insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
