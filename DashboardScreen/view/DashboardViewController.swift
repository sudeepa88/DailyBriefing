//
//  DashboardViewController.swift
//  DashboardScreen
//
//  Created by Faizan Khan on 03/11/26.
//

import UIKit

class DashboardViewController: UIViewController {
 
    // MARK: - Views
 
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
 
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
 
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = DashboardStyle.primaryText
        return label
    }()
 
    private let temperatureView = TemperatureView(temperature: 28, city: "Kolkata", condition: "Clear sky")
    private let factView = FactView(fact: "A day on Venus is longer than a year on Venus.")
    private let pictureView = PictureView(imageURLString: "https://picsum.photos/800")
 
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
 
    // MARK: - Layout
 
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
 
        stackView.addArrangedSubview(headerLabel)
        stackView.setCustomSpacing(32, after: headerLabel)
        stackView.addArrangedSubview(temperatureView)
        stackView.addArrangedSubview(makeDivider())
        stackView.addArrangedSubview(factView)
        stackView.addArrangedSubview(makeDivider())
        stackView.addArrangedSubview(pictureView)
 
        let content = scrollView.contentLayoutGuide
        let frame = scrollView.frameLayoutGuide
 
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
 
            stackView.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -24),
            stackView.widthAnchor.constraint(equalTo: frame.widthAnchor, constant: -48)
        ])
    }
 
    private func makeDivider() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.88, alpha: 1)
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return line
    }
 
    // MARK: - Updating with real data (e.g. after an API call)
 
    func update(temperature: Double, city: String, condition: String, fact: String, imageURL: URL?) {
        temperatureView.configure(temperature: temperature, city: city, condition: condition)
        factView.configure(fact: fact)
        pictureView.configure(imageURL: imageURL)
    }
}
