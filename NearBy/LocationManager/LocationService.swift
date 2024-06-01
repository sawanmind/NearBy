//
//  LocationService.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

final class LocationService {
    
    private var locationManager: LocationManagerProtocol
    
    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
    }
    
    func fetchCurrentLocation(delegate: LocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.requestLocation()
    }
}


