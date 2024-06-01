//
//  Venue.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation

struct Venue: Identifiable, Codable {
    let id: Int?
    let name: String?
    let city: String?
    let address: String?
    let url: String?
}

struct VenueResponse: Codable {
    let venues: [Venue]?
}

