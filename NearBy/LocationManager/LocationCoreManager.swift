//
//  LocationCoreManager.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import CoreLocation

final class LocationCoreManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .restricted, .denied:
            delegate?.didFailWithError(.accessNotGiven)
        @unknown default:
            let error = NSError(domain: "Unknown authorization status", code: 1, userInfo: nil)
            delegate?.didFailWithError(.unknownError(error))
        }
    }
    
    func requestLocation() {
        let status = CLLocationManager.authorizationStatus()
        handleAuthorizationStatus(status)
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let clLocation = locations.first {
            let location = Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            delegate?.didUpdateLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(.unknownError(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(status)
    }
}


