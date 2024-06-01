//
//  MockVenueService.swift
//  NearByTests
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation
import Combine

class MockVenueService: VenueServiceProtocol {
    func fetchVenues(lat: Double, lon: Double, range: String, page: Int) -> AnyPublisher<[Venue], VenueServiceError> {
        let venues = [Venue(id: 1, name: "Venue 1", city: nil, address: nil, url: nil)]
        return Result.Publisher(venues)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
