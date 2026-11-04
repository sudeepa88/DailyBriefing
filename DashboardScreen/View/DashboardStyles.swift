//
//  DashboardStyles.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import UIKit

enum DashboardStyle {
   static let accent = UIColor(red: 0.90, green: 0.34, blue: 0.18, alpha: 1)   
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

