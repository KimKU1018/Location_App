//
//  LocationMamager.swift
//  Location_App
//
//  Created by KU Kim on 2023/10/27.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    var manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    func getMyLocation( completion: @escaping (CLLocation) -> Void ) {
    
        self.completion = completion
       
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            // 내 위치정보 가져오기
            manager.startUpdatingLocation()
            
        case .authorizedAlways:
            break
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .denied:
            break
            
        case .restricted:
            break
            
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        self.completion?(location)
    }
}
