//
//  Int+Extension.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/10.
//

import Foundation

extension Int {
    
    func convertToDate(with currentTimezone: Int) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: )
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = Date(
        print(date)

        return date
        
//        return Date(timeIntervalSince1970: TimeInterval(self))
    }
        }
