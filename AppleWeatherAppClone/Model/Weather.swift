//
//  Weather.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/17.
//

import Foundation

struct CurrnetWeather {
    
    let coord: Coordintor
    let weather: [Weather]
    let tempInfo: CurrnetWeatherInfo
    @DefaultEmptyString var name: String
    let timezone: Int
}

struct Coordintor: Codable {
    
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    
    let id: Int?
    @DefaultEmptyString var state: String
    @DefaultEmptyString var description: String
    @DefaultEmptyString var icon: String
    
    enum CodingKeys: String, CodingKey {
        
        case id, description, icon
        case state = "main"
    }
}

struct CurrentTempInfo: Codable {
    
    let temp: Double?
    let tempMin: Double?
    let tempMax: Double?
    
    enum CodingKeys: String, CodingKey {
        
        case temp,
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
