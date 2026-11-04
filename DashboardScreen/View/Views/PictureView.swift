//
//  PictureView.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import UIKit

final class PictureView: UIView {

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

    init(image: UIImage? = nil) {
        super.init(frame: .zero)
        setupLayout()
        imageView.image = image
    }


   required init?(coder: NSCoder) {
       super.init(coder: coder)
       setupLayout()
   }

    func configure(image: UIImage?) {
        UIView.transition(with: imageView, duration: 0.25,
                          options: .transitionCrossDissolve) {
            self.imageView.image = image
        }
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



