//
//  WeatherListViewModel.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/10.
//

import Combine
import Foundation

class WeatherListViewModel {
    
    // MARK: -- Public Properties
    
    @Published var weathers: [WeatherInfo] = []
    
    var isLoaded = CurrentValueSubject<Bool, Never>(true)
    
    init() {
        
        self.currentWeatherWith(lat: LocationManager.shared.lat,
                                lon: LocationManager.shared.lon)                
    }
    
    // MARK: -- Public Method
    
    func currentWeatherWith(lat: Double?,
                            lon: Double?) {
        
        guard let lat = lat, let lon = lon else {
            return
        }
        
        self.isLoaded.send(true)
        
        Network.shared.requestGet(EndPoint.weatherOneCall,
                                  with: ["lat": lat,
                                         "lon": lon])
            .decode(type: WeatherInfo.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in

                switch completion {

                    case .failure(let error):

                        print(error.localizedDescription)
                        print("Combine AnyPublisher Error")

                    case .finished:

                        print("Combine AnyPublisher Finish")

                }

            }, receiveValue: {

                [weak self] weatherInfo in

                var weather = weatherInfo
                
                LocationManager.shared.locationName(lat: weatherInfo.lat,
                                                    lon: weatherInfo.lon) {
                    
                    city, gu in
                    
                    weather.city = city
                    weather.gu = gu

                    self?.isLoaded.send(false)
                    self?.weathers.append(weather)
                }
               
                print("Combine AnyPublisher")
            })
            .store(in: &self.cancellable)
        
    }
    
    private var cancellable = Set<AnyCancellable>()
}
