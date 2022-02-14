//
//  TempType+Enum.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/10.
//

import Foundation

enum TempType {
    
    case celsius
    case fahrenheit
    case kelvin
}

extension TempType {
    
    var description: String {
        
        return "\(self)"
    }
    
    var degree: String {
        
        return "°"
    }
    
    var symbol: String {
        
        switch self {
            
            case .celsius    : return "C"
            case .fahrenheit : return "F"
            case .kelvin     : return "K"
        }
    }
}
