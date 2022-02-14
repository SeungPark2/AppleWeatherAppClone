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
}
