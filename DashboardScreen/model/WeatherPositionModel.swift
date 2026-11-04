//
//  WeatherPosition.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import Foundation


struct WeatherPosition: Codable {
    let latitude: Double
    let longitude: Double
    let generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Int
    let currentWeatherUnits: CurrentWeatherUnits
    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone = "timezone"
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation = "elevation"
        case currentWeatherUnits = "current_weather_units"
        case currentWeather = "current_weather"
    }
}


// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let time: String
    let interval: Int
    let temperature: Double
    let windspeed: Int
    let winddirection: Int
    let isDay: Int
    let weathercode: Int

    enum CodingKeys: String, CodingKey {
        case time = "time"
        case interval = "interval"
        case temperature = "temperature"
        case windspeed = "windspeed"
        case winddirection = "winddirection"
        case isDay = "is_day"
        case weathercode = "weathercode"
    }
}

// MARK: - CurrentWeatherUnits
struct CurrentWeatherUnits: Codable {
    let time: String
    let interval: String
    let temperature: String
    let windspeed: String
    let winddirection: String
    let isDay: String
    let weathercode: String

    enum CodingKeys: String, CodingKey {
        case time = "time"
        case interval = "interval"
        case temperature = "temperature"
        case windspeed = "windspeed"
        case winddirection = "winddirection"
        case isDay = "is_day"
        case weathercode = "weathercode"
    }
}


