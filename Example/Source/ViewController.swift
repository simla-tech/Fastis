//
//  ViewController.swift
//  Example
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Fastis
import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets

    private lazy var containerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var currentDateLabel = UILabel()
    let calendar = Calendar(identifier: .gregorian)

    private lazy var chooseRangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose range of dates", for: .normal)
        button.addTarget(self, action: #selector(self.chooseRange), for: .touchUpInside)
        return button
    }()

    private lazy var chooseSingleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose single date", for: .normal)
        button.addTarget(self, action: #selector(self.chooseSingleDate), for: .touchUpInside)
        return button
    }()

    // MARK: - Variables

    private var currentValue: FastisValue? {
        didSet {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if let rangeValue = self.currentValue as? FastisRange {
                self.currentDateLabel.text = formatter.string(from: rangeValue.fromDate) + " - " + formatter.string(from: rangeValue.toDate)
            } else if let date = self.currentValue as? Date {
                self.currentDateLabel.text = formatter.string(from: date)
            } else {
                self.currentDateLabel.text = "Choose a date"
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureSubviews()
        self.configureConstraints()
    }

    // MARK: - Configuration

    private func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Fastis demo"
        self.navigationItem.largeTitleDisplayMode = .always
        self.currentValue = nil
    }

    private func configureSubviews() {
        self.containerView.addArrangedSubview(self.currentDateLabel)
        self.containerView.setCustomSpacing(32, after: self.currentDateLabel)
        self.containerView.addArrangedSubview(self.chooseRangeButton)
        self.containerView.addArrangedSubview(self.chooseSingleButton)
        self.view.addSubview(self.containerView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.containerView.leftAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.containerView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.containerView.rightAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc
    private func chooseRange() {
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
        fastisController.minimumMonthDate = 0
        fastisController.maximumMonthDate = 0
//        fastisController.initialValue = self.currentValue as? FastisRange
//        fastisController.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
//        fastisController.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        let calendar = Calendar(identifier: .gregorian)
  
        fastisController.minimumDate = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2024, month: 1, day: 1))
        fastisController.maximumDate =  calendar.date(from: DateComponents(year: 2024, month: 12, day: 31))
        fastisController.allowToChooseNilDate = true
//        fastisController.shortcuts = [.today, .lastWeek, .lastMonth]
        fastisController.dismissHandler = { [weak self] action in
            switch action {
            case .done(let newValue):
                self?.currentValue = newValue
            case .cancel:
                print("any actions")
            }
        }
        fastisController.present(above: self)
    }

    @objc
    private func chooseSingleDate() {
        let fastisController = FastisController(mode: .single)
        fastisController.title = "Choose date"
        fastisController.initialValue = self.currentValue as? Date
        fastisController.maximumDate = Date()
        fastisController.shortcuts = [.today, .yesterday, .tomorrow]
        fastisController.dismissHandler = { [weak self] action in
            switch action {
            case .done(let newValue):
                self?.currentValue = newValue
            case .cancel:
                print("any actions")
            }
        }
        fastisController.present(above: self)
    }

}
