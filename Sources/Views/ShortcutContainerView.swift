//
//  ShortcutView.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit

final class ShortcutContainerView<Value: FastisValue>: UIView {

    // MARK: - Outlets

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = self.config.itemSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        self.configureConstraints()
    }

    @available(*, unavailable)
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

    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.stackView.leftAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leftAnchor, constant: self.config.insets.left),
            self.stackView.rightAnchor.constraint(
                equalTo: self.scrollView.contentLayoutGuide.rightAnchor,
                constant: -self.config.insets.right
            ),
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor, constant: self.config.insets.top),
            self.stackView.bottomAnchor.constraint(
                equalTo: self.scrollView.contentLayoutGuide.bottomAnchor,
                constant: -self.config.insets.bottom
            )
        ])
        NSLayoutConstraint.activate([
            self.scrollView.heightAnchor.constraint(
                equalTo: self.stackView.heightAnchor,
                constant: self.config.insets.top + self.config.insets.bottom
            ),
            self.scrollView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Actions

}

public extension FastisConfig {

    /**
     Bottom view with shortcuts

     Configurable in FastisConfig.``FastisConfig/shortcutContainerView-swift.property`` property
     */
    struct ShortcutContainerView {

        /**
         Background color of container

         Default value — `.secondarySystemBackground`
         */
        public var backgroundColor: UIColor = .secondarySystemBackground

        /**
         Spacing between items

         Default value — `12pt`
         */
        public var itemSpacing: CGFloat = 12

        /**
         Container inner inset

         Default value — `UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)`
         */
        public var insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    }
}
