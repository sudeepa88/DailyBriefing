//
//  FactView.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import UIKit

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
