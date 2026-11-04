//
//  WeatherPosition.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import Foundation

struct WeatherPositionModel: Codable {
    let latitude: Double
    let longitude: Double
    let generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Double
    let currentWeatherUnits: CurrentWeatherUnits
    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentWeatherUnits = "current_weather_units"
        case currentWeather = "current_weather"
    }
}

struct CurrentWeather: Codable {
    let time: String
    let interval: Int
    let temperature: Double
    let windspeed: Double
    let winddirection: Double
    let isDay: Int
    let weathercode: Int

    enum CodingKeys: String, CodingKey {
        case time
        case interval
        case temperature
        case windspeed
        case winddirection
        case isDay = "is_day"
        case weathercode
    }
}

struct CurrentWeatherUnits: Codable {
    let time: String
    let interval: String
    let temperature: String
    let windspeed: String
    let winddirection: String
    let isDay: String
    let weathercode: String

    enum CodingKeys: String, CodingKey {
        case time
        case interval
        case temperature
        case windspeed
        case winddirection
        case isDay = "is_day"
        case weathercode
    }
}
