//
//  TemperatureView.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//


import UIKit

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



   private let iconView: UIImageView = {
       let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
       let iv = UIImageView(image: UIImage(systemName: "sun.max", withConfiguration: config))
       iv.tintColor = DashboardStyle.accent
       iv.contentMode = .scaleAspectFit
       iv.translatesAutoresizingMaskIntoConstraints = false
       return iv
   }()

//initialization with the datas
   init(temperature: Double) {
       super.init(frame: .zero)
       setupLayout()
       configure(temperature: temperature)
   }

   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupLayout()
   }

   func configure(temperature: Double) {
      
       temperatureLabel.text = "\(Int(temperature.rounded()))°C"
    
   }

   private func setupLayout() {
       translatesAutoresizingMaskIntoConstraints = false
       [titleLabel, temperatureLabel,  iconView].forEach(addSubview)

       NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: topAnchor),
           titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

           temperatureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
           temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
           temperatureLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconView.leadingAnchor, constant: -12),
           temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

           iconView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
           iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
           iconView.widthAnchor.constraint(equalToConstant: 56),
           iconView.heightAnchor.constraint(equalToConstant: 56)
       ])
   }
}
