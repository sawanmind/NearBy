//
//  VenueService.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation
import Combine

protocol VenueServiceProtocol {
    func fetchVenues(lat: Double, lon: Double, range: String, page: Int) -> AnyPublisher<[Venue], VenueServiceError>
}

struct VenueService: VenueServiceProtocol {
    
    func fetchVenues(lat: Double, lon: Double, range: String, page: Int) -> AnyPublisher<[Venue], VenueServiceError> {
        guard var urlComponents = URLComponents(string: VenueServiceConstant.baseURL.description) else {
            return Fail(error: VenueServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: VenueServiceConstant.clientID.description),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "range", value: range)
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: VenueServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { VenueServiceError.networkError($0) }
            .decode(type: VenueResponse.self, decoder: JSONDecoder())
            .map { $0.venues ?? [] }
            .mapError { VenueServiceError.decodingError($0) }
            .eraseToAnyPublisher()
    }
}


