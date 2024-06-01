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
    
    init(id: Int?, name: String?, city: String?, address: String?, url: String?) {
        self.id = id
        self.name = name
        self.city = city
        self.address = address
        self.url = url
    }
}

struct VenueResponse: Codable {
    let venues: [Venue]?
}

