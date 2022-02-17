//
//  Array+Extension.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/17.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {

        return indices ~= index ? self[index] : nil
    }
}
