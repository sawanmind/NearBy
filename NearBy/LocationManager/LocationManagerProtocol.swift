//
//  LocationManagerProtocol.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import CoreLocation

protocol LocationManagerProtocol {
    var delegate: LocationManagerDelegate? { get set }
    func requestLocation()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: Location)
    func didFailWithError(_ error: LocationError)
}

struct Location {
    let latitude: Double
    let longitude: Double
}

