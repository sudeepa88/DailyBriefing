//
//  DashboardStyles.swift
//  DashboardScreen
//
//  Created by Faizan Khan on 03/11/26.
//

import UIKit




enum DashboardStyle {
   static let accent = UIColor(red: 0.90, green: 0.34, blue: 0.18, alpha: 1)   // orange-red
   static let primaryText = UIColor(white: 0.07, alpha: 1)
   static let secondaryText = UIColor(white: 0.40, alpha: 1)
   static let placeholderBackground = UIColor(white: 0.95, alpha: 1)

   static func sectionLabel(_ text: String) -> UILabel {
       let label = UILabel()
       label.text = text
       label.font = .systemFont(ofSize: 15, weight: .regular)
       label.textColor = secondaryText
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }
}

// MARK: - 1. Temperature view

final class TemperatureView: UIView {

   private let titleLabel = DashboardStyle.sectionLabel("Temperature")

   private let temperatureLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 80, weight: .regular)
       label.textColor = DashboardStyle.primaryText
       label.adjustsFontSizeToFitWidth = true
       label.minimumScaleFactor = 0.5
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()

   private let conditionLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 17, weight: .regular)
       label.textColor = DashboardStyle.secondaryText
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()

   private let iconView: UIImageView = {
       let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
       let iv = UIImageView(image: UIImage(systemName: "sun.max", withConfiguration: config))
       iv.tintColor = DashboardStyle.accent
       iv.contentMode = .scaleAspectFit
       iv.translatesAutoresizingMaskIntoConstraints = false
       return iv
   }()

   /// - Parameters:
   ///   - temperature: temperature in °C
   ///   - city: shown next to the "Temperature" title
   ///   - condition: e.g. "Clear sky"
   init(temperature: Double, city: String = "Kolkata", condition: String = "Clear sky") {
       super.init(frame: .zero)
       setupLayout()
       configure(temperature: temperature, city: city, condition: condition)
   }

   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupLayout()
   }

   func configure(temperature: Double, city: String, condition: String) {
       titleLabel.text = "Temperature · \(city)"
       temperatureLabel.text = "\(Int(temperature.rounded()))°C"
       conditionLabel.text = condition
   }

   private func setupLayout() {
       translatesAutoresizingMaskIntoConstraints = false
       [titleLabel, temperatureLabel, conditionLabel, iconView].forEach(addSubview)

       NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: topAnchor),
           titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

           temperatureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
           temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           temperatureLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconView.leadingAnchor, constant: -12),

           conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
           conditionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           conditionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

           iconView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
           iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
           iconView.widthAnchor.constraint(equalToConstant: 56),
           iconView.heightAnchor.constraint(equalToConstant: 56)
       ])
   }
}

// MARK: - 2. Fact view

final class FactView: UIView {

   private let titleLabel = DashboardStyle.sectionLabel("Did you know?")

   private let factLabel: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: 24, weight: .medium)
       label.textColor = DashboardStyle.primaryText
       label.numberOfLines = 0
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()

   init(fact: String) {
       super.init(frame: .zero)
       setupLayout()
       configure(fact: fact)
   }

   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupLayout()
   }

   func configure(fact: String) {
       factLabel.text = fact
   }

   private func setupLayout() {
       translatesAutoresizingMaskIntoConstraints = false
       [titleLabel, factLabel].forEach(addSubview)

       NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: topAnchor),
           titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

           factLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
           factLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           factLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
           factLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
       ])
   }
}

// MARK: - 3. Picture view

final class PictureView: UIView {

   private static let cache = NSCache<NSURL, UIImage>()

   private let titleLabel = DashboardStyle.sectionLabel("Picture")

   private let imageView: UIImageView = {
       let iv = UIImageView()
       iv.backgroundColor = DashboardStyle.placeholderBackground
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
       iv.layer.cornerRadius = 16
       iv.translatesAutoresizingMaskIntoConstraints = false
       return iv
   }()

   private let spinner: UIActivityIndicatorView = {
       let s = UIActivityIndicatorView(style: .medium)
       s.hidesWhenStopped = true
       s.translatesAutoresizingMaskIntoConstraints = false
       return s
   }()

   private var task: URLSessionDataTask?
   private var currentURL: URL?

   init(imageURL: URL?) {
       super.init(frame: .zero)
       setupLayout()
       configure(imageURL: imageURL)
   }

   /// Convenience for a URL string
   convenience init(imageURLString: String) {
       self.init(imageURL: URL(string: imageURLString))
   }

   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupLayout()
   }

   func configure(imageURL: URL?) {
       task?.cancel()
       imageView.image = nil
       currentURL = imageURL
       guard let url = imageURL else { return }

       if let cached = Self.cache.object(forKey: url as NSURL) {
           imageView.image = cached
           return
       }

       spinner.startAnimating()
       task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
           let image = data.flatMap(UIImage.init(data:))
           if let image { Self.cache.setObject(image, forKey: url as NSURL) }
           DispatchQueue.main.async {
               guard let self, self.currentURL == url else { return }
               self.spinner.stopAnimating()
               if let image {
                   UIView.transition(with: self.imageView, duration: 0.25,
                                     options: .transitionCrossDissolve) {
                       self.imageView.image = image
                   }
               }
           }
       }
       task?.resume()
   }

   private func setupLayout() {
       translatesAutoresizingMaskIntoConstraints = false
       [titleLabel, imageView].forEach(addSubview)
       imageView.addSubview(spinner)

       NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: topAnchor),
           titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

           imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
           imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
           imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
           imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
           imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor), // square, like the design

           spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
           spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
       ])
   }
}



