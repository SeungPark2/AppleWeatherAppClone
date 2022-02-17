//
//  LocationManager.swift
//  AppleWeatherAppClone
//
//  Created by 박승태 on 2022/02/10.
//

import CoreLocation

class LocationManager: NSObject {
    
    // Singleton
    
    static let shared: LocationManager = LocationManager()
    private override init() { }
    
    var lat: Double? {
        get { return self.latitude }
        set { self.latitude = newValue }
    }
    
    var lon: Double? {
        get { return self.longitude }
        set { self.longitude = newValue }
    }
    
    func locationName(lat: Double?,
                      lon: Double?,
                      completion: @escaping (_ city: String, _ gu: String) -> Void) {
        
        guard let lat = lat,
              let lon = lon else {
                                    
            return completion("", "")
        }
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat,
                                                       longitude: lon)) {
            
            placemark, error in
            
            completion(placemark?.first?.administrativeArea ?? "",
                       placemark?.first?.locality ?? "")
        }
    }
    
    private var latitude: Double?
    private var longitude: Double?
    
    private let locationManager = CLLocationManager()
}

extension LocationManager {
        
    func checkPermission() {
        
        self.locationManager.delegate = self
        
        switch self.locationManager.authorizationStatus {
            
            case .notDetermined:
                
                self.locationManager.requestWhenInUseAuthorization()
                
            case .authorizedWhenInUse, .authorizedAlways:
                
                self.locationManager.startUpdatingLocation()
                self.latitude = self.locationManager.location?.coordinate.latitude
                self.longitude = self.locationManager.location?.coordinate.longitude
            
        default: break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedAlways ||
           manager.authorizationStatus == .authorizedWhenInUse {
            
            self.locationManager.startUpdatingLocation()
            self.latitude = manager.location?.coordinate.latitude
            self.longitude = manager.location?.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        self.latitude = locations.first?.coordinate.latitude
        self.longitude = locations.first?.coordinate.longitude
    }
}
