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
    @DefaultEmptyString var base: String
    let tempInfo: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt: Int?
    let sys: Sys
    let timezone: Int?
    let id: Int?
    @DefaultEmptyString var name: String
    let cod: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case coord, weather, base
        case visibility, wind, clouds, dt
        case sys, timezone, id, name, cod
        case tempInfo = "main"
    }
}

struct Coordinate: Codable {
    
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    
    let id: Int?
    @DefaultEmptyString var main: String
    @DefaultEmptyString var state: String
    @DefaultEmptyString var icon: String
    
    enum CodingKeys: String, CodingKey {
        
        case id, main, icon
        case state = "description"
    }
}

struct Main: Codable {
    
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin   = "temp_min"
        case tempMax   = "temp_max"
    }    
}

struct Wind: Codable {
    
    let speed: Double?
    let deg: Int?
}

struct Clouds: Codable {
    
    let all: Int?
}

struct Sys: Codable {
    
    var type: Int?
    var id: Int?
    @DefaultEmptyString var country: String
    var sunrise: Int?
    var sunset: Int?
}
