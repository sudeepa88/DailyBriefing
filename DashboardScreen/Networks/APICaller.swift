//
//  APICaller.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import Foundation
import UIKit


public class APICaller {

    //MARK: API Calling for Weather Data
    
    static func getWeatherData() async throws -> WeatherPositionModel {
        let urlString = NetworkConstants.shared.weatherAddress
        
        guard let url = URL(string: urlString) else {
            print("API ERROR: Invalid URL")
            throw NetworkError.urlError
        }

        // Await the network response
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode JSON
        let weatherData = try JSONDecoder().decode(
            WeatherPositionModel.self,
            from: data
        )

        return weatherData
    }
    
    //MARK:  Calling Random fact Data
    
    static func getRandomFacts() async throws -> RandomFactModel {
        
        //Taking url String
        let urlString = NetworkConstants.shared.randomFactAddress
        //1. Converting url string into URL Object
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlError
        }
        
        //2. URLSession For network request
        let (data, _) = try await URLSession.shared.data(from: url)
        //3. Json Decoding
        let randomFactData = try JSONDecoder().decode(RandomFactModel.self, from: data)
        return randomFactData
    }
    
    
    //MARK: Calling Dog Image data
    
    static func getDogImg() async throws -> DogImgModel {
        //Taking url string
        let urlString = NetworkConstants.shared.dogImgAddress
        //1.Converting url string into URL Object
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlError
        }
        
        //2. URLSession for Network
        let (data, _) = try await URLSession.shared.data(from: url)
        //3. Json Decoding
        
        let dogImgData = try JSONDecoder().decode(DogImgModel.self, from: data)
        return dogImgData
    }
    
    
    
    //MARK: Downloading an image from a URL
    
    private static let imageCache = NSCache<NSURL, UIImage>()
    
    static func downloadImage(from urlString: String) async throws -> UIImage {
        //1. Converting url string into URL Object
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlError
        }
        
        //2. Return from cache if we already downloaded it
        if let cached = imageCache.object(forKey: url as NSURL) {
            return cached
        }
        
        //3. URLSession for Network
        let (data, _) = try await URLSession.shared.data(from: url)
        
        //4. Converting data into UIImage
        guard let image = UIImage(data: data) else {
            throw NetworkError.urlError
        }
        
        imageCache.setObject(image, forKey: url as NSURL)
        return image
    }
    
}
