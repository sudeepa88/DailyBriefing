//
//  WeatherPostionViewModel.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//


import Foundation



@MainActor
class WeatherPostionViewModel {

    private var weatherData: WeatherPositionModel?

    func getWeatherData() async throws -> WeatherPositionModel {
        do {
            let data = try await APICaller.getWeatherData()
            self.weatherData = data
            return data

        } catch {
            throw error
        }
    }
}


