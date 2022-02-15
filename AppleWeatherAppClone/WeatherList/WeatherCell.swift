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
        
        self.placeNameLabel?.text = weather.name
        self.currentTimeLabel?.text = weather.dt
                                             .convertToDate(with: weather.timezone)
                                             .convertMonthAndDay()
        self.currentTempLabel?.text = "\(weather.tempInfo.currentCelsius)\(tempType.degree)"
        
        self.currentWeatherStateLabel?.text = weather.weather.first?.state ?? ""
        self.highAndLowTempLabel?.text = "최고: \(weather.tempInfo.maxCelsius)\(tempType.degree) " +
                                         "최저: \(weather.tempInfo.minCelsius)\(tempType.degree)"
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
