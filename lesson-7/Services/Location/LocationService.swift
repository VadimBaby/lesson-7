//
//  LocationService.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Combine
import CoreLocation

protocol LocationServiceProtocol {
    var currentLocation: CurrentValueSubject<CLLocationCoordinate2D?, Never> { get }
    
    func requestLocation()
}

final class LocationService: NSObject, LocationServiceProtocol {
    private var manager = CLLocationManager()
    
    let currentLocation = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
    
    override init() {
        super.init()
        
        requestAuth()
        setupLocationManager()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
}

private extension LocationService {
    func setupLocationManager() {
        manager.delegate = self
    }
    
    func requestAuth() {
        switch manager.authorizationStatus {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined, .restricted, .denied:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let sortedLocations = locations.sorted { $0.horizontalAccuracy < $1.horizontalAccuracy }
        
        guard let bestLocation = sortedLocations.first else { return }
        
        print("send location: \(bestLocation.coordinate)")
        currentLocation.send(bestLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error")
        debugPrint(error)
    }
}
