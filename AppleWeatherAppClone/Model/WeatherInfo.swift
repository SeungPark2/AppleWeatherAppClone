//
//  WeatherInfo.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/03.
//

import Foundation

struct WeatherInfo: Codable {
    
    let lat: Double?
    let lon: Double?
    var city: String?
    var gu: String?
    @DefaultEmptyString var timezone: String
    let timezoneOffset: Int?
    let current: CurrnetWeatherInfo
    let hourly: [Hourly]
    let daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
    
        case lat, lon, timezone, current, hourly, daily
        case timezoneOffset = "timezone_offset"
    }
    
    func celsius(of strength: TempStrength) -> String {
        
        var temp: Double?
        
        switch strength {
            
        case .min:     temp = self.daily.first?.tempInfo.min
        case .current: temp = self.current.temp
        case .max:     temp = self.daily.first?.tempInfo.max
        }
        
        guard let unwrappedTemp = temp else {
            
            return ""
        }
        
        return "\(Int(unwrappedTemp - 273.15))\(TempType.degree)"
    }
    
    func fahrenheit(of strength: TempStrength) -> String {
        
        var temp: Double?
        
        switch strength {
            
        case .min:     temp = self.daily.first?.tempInfo.min
        case .current: temp = self.current.temp
        case .max:     temp = self.daily.first?.tempInfo.max
        }
        
        guard let unwrappedTemp = temp else {
            
            return ""
        }
        
        return "\(Int(unwrappedTemp * 1.8) + 32)\(TempType.degree)"
    }
}

struct CurrnetWeatherInfo: Codable {
    
    let time: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Double?
    let feelsLike: Double?
    let humidity: Int?    // 습도
    let dewPoint: Double? // 이슬점
    let uvi: Double?      // 자외선 지수
    let clouds: Int?
    let visibility: Int?  // 가시거리
    let windSpeed: Double?
    let windDeg: Int?     // 풍향
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        
        case sunrise, sunset, temp, humidity, uvi,
             clouds, visibility, weather
        case time      = "dt"
        case feelsLike  = "feels_like"
        case dewPoint  = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg   = "wind_deg"
    }
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

struct Hourly: Codable {
    
    let time: Int?
    let temp: Double?
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
    
        case temp, weather
        case time = "dt"
    }
}

struct Daily: Codable {
    
    let time: Int?
    let tempInfo: TempInfo
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
    
        case time = "dt"
        case tempInfo = "temp"
        case weather
    }
}

struct TempInfo: Codable {
    
    let min: Double?
    let max: Double?
}
