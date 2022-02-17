//
//  WeatherCell.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/09.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    static let identifier: String = "WeatherCell"
    
    func updateUI(with weather: WeatherInfo,
                  tempType: TempType) {
        
        self.placeNameLabel?.text = weather.gu
        self.currentWeatherStateLabel?.text = weather.current.weather.first?.description ?? ""
        
        if let dateTime = weather.current.time,
           let timezone = weather.timezoneOffset {
            
            self.currentTimeLabel?.text = dateTime.convertToDate(with: timezone)
                                                  .convertMonthAndDay()
        }
        else {
            
            self.currentTimeLabel?.text = ""
        }
        
        self.currentTempLabel?.text = tempType == .celsius ?
                                      weather.celsius(of: .current) :
                                      weather.fahrenheit(of: .current)
        
        let tempMax = tempType == .celsius ?
                      weather.celsius(of: .max) :
                      weather.fahrenheit(of: .max)
        
        let tempMin = tempType == .celsius ?
                      weather.celsius(of: .min) :
                      weather.fahrenheit(of: .min)
        
        self.highAndLowTempLabel?.text = "최고: \(tempMax) 최저: \(tempMin)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .blue
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
    }
    
    @IBOutlet private weak var placeNameLabel: UILabel?
    @IBOutlet private weak var currentTimeLabel: UILabel?
    @IBOutlet private weak var currentWeatherStateLabel: UILabel?
    @IBOutlet private weak var currentTempLabel: UILabel?
    @IBOutlet private weak var highAndLowTempLabel: UILabel?
}
