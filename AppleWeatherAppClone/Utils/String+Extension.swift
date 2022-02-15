//
//  String+Extension.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/13.
//

import Foundation

extension String {
    
    func getCharacter(_ index: Int) -> String {
        
        if self.count < index + 1 {
            
            return ""
        }
        
        let findIndex = self.index(self.startIndex,
                                   offsetBy: index)
        
        return String(self[findIndex])
    }
    
    func convertMonthAndDay() -> String {
                
        if self.count < 16 { return self }
        
        var convertString = ""
        
        let hour = Int(self.getCharacter(11) + self.getCharacter(12)) ?? 0
        
        convertString = hour > 12 ? "오후 \(hour - 12):" :
                                    "오전 \(hour):"
        
        convertString += self.getCharacter(14) + self.getCharacter(15)
        
        return convertString
    }
    
}
