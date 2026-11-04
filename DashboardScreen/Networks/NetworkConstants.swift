//
//  NetworkConstants.swift
//  DashboardScreen
//
//  Created by Sudeepa on 03/11/26.
//

import Foundation

class NetworkConstants {
    public static var shared:NetworkConstants = NetworkConstants()
    
    private init() {}
    
    
    public var weatherAddress:String {
        get {
            return "https://api.open-meteo.com/v1/forecast?latitude=37.7749&longitude=-122.4194&current_weather=true"
        }
    }
    
    
    public var randomFactAddress:String {
        get {
            return "https://uselessfacts.jsph.pl/api/v2/facts/random"
        }
    }
    
    public var dogImgAddress:String {
        get {
            return "https://dog.ceo/api/breeds/image/random"
        }
    }
}

