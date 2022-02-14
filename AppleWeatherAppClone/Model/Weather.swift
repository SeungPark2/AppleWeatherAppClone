//
//  Weather.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/03.
//

import Foundation

struct WeatherInfo: Codable {
    
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let tempInfo: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    enum CodingKeys: String, CodingKey {
        
        case coord, weather, base
        case visibility, wind, clouds, dt
        case sys, timezone, id, name, cod
        case tempInfo = "main"
    }
}

struct Coordinate: Codable {
    
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    
    let id: Int
    let main: String
    let state: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        
        case id, main, icon
        case state = "description"
    }
}

struct Main: Codable {
    
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin   = "temp_min"
        case tempMax   = "temp_max"
    }
    
    var currentCelsius: Int {
        
        get { Int(self.temp - 273.15) }
    }
    
    var currnetFahrenheit: Int {
        
        get { Int(Double(self.currentCelsius) * 1.8) + 32 }
    }
    
    var maxCelsius: Int {
        
        get { Int(self.tempMax - 273.15) }
    }
    
    var maxFahrenheit: Int {
        
        get { Int(Double(self.maxCelsius) * 1.8) + 32 }
    }
    
    var minCelsius: Int {
        
        get { Int(self.tempMin - 273.15) }
    }
    
    var minFahrenheit: Int {
        
        get { Int(Double(self.minCelsius) * 1.8) + 32 }
    }
}

struct Wind: Codable {
    
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    
    let all: Int
}

struct Sys: Codable {
    
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
