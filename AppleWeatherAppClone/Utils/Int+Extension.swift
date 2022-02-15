//
//  Int+Extension.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/10.
//

import Foundation

extension Int {
    
    func convertToDate(with currentTimezone: Int) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: currentTimezone)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        return dateFormatter.string(from: date)
    }
}
