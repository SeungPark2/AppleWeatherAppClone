//
//  Date+Extension.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/13.
//

import Foundation

extension Date {
    
    func calcuateGMT(time: Int) -> String {
        let timeZone = abs(time) / 3600
        let compare = time < 0 ? "-" : "+"

        if timeZone < 10 {
            
            return "GMT\(compare)0\(timeZone)"
            
        }
        else {
            
            return "GMT\(compare)\(timeZone)"
        }
    }
    
    func convertToStringAtMonthAndDay() -> String {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM:dd"
        
        let dateString = dateformatter.string(from: self)
        
        if dateString.count < 5 { return dateString }
        
        var convertString = ""
        
        if (Int(dateString.getCharacter(0) + dateString.getCharacter(1)) ?? 0) > 11 {
            
            convertString = "오후 "
        }
        else {
            
            convertString = "오전 "
        }
        
        if dateString.getCharacter(0) != "0" {
            
            convertString = dateString.getCharacter(0)
        }
        
        convertString += dateString.getCharacter(1)
        
        convertString += ":"
                
        if dateString.getCharacter(3) != "0" {
            
            convertString += dateString.getCharacter(3)
        }
        
        convertString += dateString.getCharacter(5)
        
        return convertString
    }
}

