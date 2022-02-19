//
//  ShortcutCell.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit
import SnapKit
import PrettyCards

class ShortcutItemView: UIView {

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
        return card
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = self.config.font
        label.textColor = self.config.textColor
        label.textAlignment = .center
        return label
    }()

    // MARK: - Variables

    private let config: FastisConfig.ShortcutItemView
    internal var tapHandler: (() -> Void)?

    internal var isSelected: Bool = false {
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
            return self.nameLabel.text
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
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(self.config.insets)
        }
        self.container.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    // MARK: - Actions

}

extension FastisConfig {
    public struct ShortcutItemView {
        public var cornerRadius: CGFloat = 4
        public var tapAnimation: Card.Animation = .zoomOut
        public var backgroundColor: UIColor = .white
        public var selectedBackgroundColor: UIColor = .systemBlue
        public var font: UIFont = .systemFont(ofSize: 15, weight: .regular)
        public var textColor: UIColor = .black
        public var textColorOnSelected: UIColor = .white
        public var shadow: CardShadowProtocol = Card.Shadow.small
        public var insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
}
