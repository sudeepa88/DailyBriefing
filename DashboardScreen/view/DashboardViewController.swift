//
//  DashboardViewController.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import UIKit

class DashboardViewController: UIViewController {
    
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
        label.text = "Daily Briefing"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = DashboardStyle.primaryText
        return label
    }()
    
//    private let temperatureView = TemperatureView(temperature: 28, city: "Kolkata", condition: "Clear sky")
    private let temperatureView = TemperatureView(temperature: 28)
    private let factView = FactView(fact: "A day on Venus is longer than a year on Venus.")
    private let pictureView = PictureView(image: UIImage(systemName: "photo"))
    
    
    var weatherViewModel: WeatherPostionViewModel = WeatherPostionViewModel()
    var factViewModel: RandomFactViewModel = RandomFactViewModel()
    var dogImgViewModel: DogImgViewModel = DogImgViewModel()
    
    
    //For task controlling
    private var loadTask: Task<Void, Never>?
    
    
    // MARK: - Loader
    
    /// Full-screen overlay that blocks touches while data loads.
    private let loaderOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = DashboardStyle.accent
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDashboardData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadTask?.cancel()
    }
    
    
    //MARK: All the dashboard data
    
    private func loadDashboardData() {
        loadTask?.cancel()
        showLoader()
        loadTask = Task { [weak self] in
            await withTaskGroup(of: String.self) { group in
                //1. 1st Task
                group.addTask {
                    do {
                        
                        let weather = try await self?.weatherViewModel.getWeatherData()
                        await MainActor.run {
                            self?.temperatureView.configure(
                                temperature: weather?.currentWeather.temperature ?? 00,
                            )
                        }
                        return "Weather is too gawdd\(weather?.currentWeather.temperature)"
                        
                    } catch {
                        return "Weather failed: \(error.localizedDescription)"
                    }
                    
                }
                
                //2. 2nd Task
                group.addTask {
                    do {
                        let fact = try await self?.factViewModel.getRandomFact()
                        await MainActor.run {
                            self?.factView.configure(fact: fact?.text ?? "No data")
                        }
                        return "Fact: \(fact?.text)"
                    } catch {
                        return "Fact failed: \(error.localizedDescription)"
                    }
                }
                
                //3. 3rd Task
                group.addTask {
                    do {
                        let img = try await self?.dogImgViewModel.getDogImage()
                        //guard let url = URL(string: img?.message ?? "") else { return ""}
                        await MainActor.run {
                            self?.pictureView.configure(image: img)
                        }
                        
                        return "Image: \(img)"
                    } catch {
                        return "Image failed: \(error.localizedDescription)"
                    }
                }
                
                // Collecting results
                for await result in group {
                    print("Fetched data: \(result)")
                }
            }
            
            guard !Task.isCancelled else { return }
            
            self?.hideLoader()
        }
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
    
    
    //MARK: Loader Section
    
    private func setupLoader() {
        view.addSubview(loaderOverlay)
        loaderOverlay.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            loaderOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loaderOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loaderOverlay.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loaderOverlay.centerYAnchor)
        ])
    }
    
    private func showLoader() {
        view.bringSubviewToFront(loaderOverlay)
        loaderOverlay.alpha = 1
        loaderOverlay.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoader() {
        UIView.animate(withDuration: 0.25, animations: {
            self.loaderOverlay.alpha = 0
        }, completion: { _ in
            self.activityIndicator.stopAnimating()
            self.loaderOverlay.isHidden = true
        })
    }

}


