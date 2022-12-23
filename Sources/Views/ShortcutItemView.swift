//
//  ShortcutCell.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import PrettyCards
import UIKit

final class ShortcutItemView: UIView {

    // MARK: - Outlets

    private lazy var container: Card = {
        let card = Card()
        card.backgroundColor = self.config.backgroundColor
        card.cornerRadius = self.config.cornerRadius
        card.animation = self.config.tapAnimation
        card.setShadow(self.config.shadow)
        card.tapHandler = {
            self.tapHandler?()
        }
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = self.config.font
        label.textColor = self.config.textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Variables

    private let config: FastisConfig.ShortcutItemView
    internal var tapHandler: (() -> Void)?

    internal var isSelected = false {
        didSet {
            guard self.isSelected != oldValue else { return }
            UIView.animate(withDuration: 0.1) {
                self.container.backgroundColor = self.isSelected ? self.config.selectedBackgroundColor : self.config.backgroundColor
                self.nameLabel.textColor = self.isSelected ? self.config.textColorOnSelected : self.config.textColor
            }
        }
    }

    internal var name: String? {
        get {
            self.nameLabel.text
        }
        set {
            self.nameLabel.text = newValue
        }
    }

    // MARK: - Lifecycle

    init(config: FastisConfig.ShortcutItemView) {
        self.config = config
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

    private func configureUI() {
        self.backgroundColor = .clear
    }

    private func configureSubviews() {
        self.container.containerView.addSubview(self.nameLabel)
        self.addSubview(self.container)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.nameLabel.leftAnchor.constraint(equalTo: self.container.containerView.leftAnchor, constant: self.config.insets.left),
            self.nameLabel.rightAnchor.constraint(equalTo: self.container.containerView.rightAnchor, constant: -self.config.insets.right),
            self.nameLabel.topAnchor.constraint(equalTo: self.container.containerView.topAnchor, constant: self.config.insets.top),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.container.containerView.bottomAnchor, constant: -self.config.insets.bottom)
        ])
        NSLayoutConstraint.activate([
            self.container.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.container.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.container.topAnchor.constraint(equalTo: self.topAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    // MARK: - Actions

}

public extension FastisConfig {

    /**
     Shortcut item in the bottom view

     Configurable in FastisConfig.``FastisConfig/shortcutItemView-swift.property`` property
     */
    struct ShortcutItemView {

        /**
         Corner radius of item

         Default value — `6pt`
         */
        public var cornerRadius: CGFloat = 6

        /**
         Animation on touch

         Default value — `.zoomOut`
         */
        public var tapAnimation: Card.Animation = .zoomOut

        /**
         Background color of item

         Default value — `.systemBackground`
         */
        public var backgroundColor: UIColor = .systemBackground

        /**
         Background color of item when it value equals selected date

         Default value — `.systemBlue`
         */
        public var selectedBackgroundColor: UIColor = .systemBlue

        /**
         Font of label in item

         Default value — `.systemFont(ofSize: 15, weight: .regular)`
         */
        public var font: UIFont = .systemFont(ofSize: 15, weight: .regular)

        /**
         Text color of label in item

         Default value — `.label`
         */
        public var textColor: UIColor = .label

        /**
         Text color of label in item when it value equals selected date

         Default value — `.white`
         */
        public var textColorOnSelected: UIColor = .white

        /**
         Shadow of item

         Default value — `Card.Shadow.small`
         */
        public var shadow: CardShadowProtocol = Card.Shadow.small

        /**
         Inner inset of item

         Default value — `UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)`
         */
        public var insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    }

}
