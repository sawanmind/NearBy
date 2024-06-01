//
//  VenueServiceConstant.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation

enum VenueServiceConstant: CustomStringConvertible {
    
    case baseURL
    case clientID
    
    var description: String {
        switch self {
        case .baseURL:
            return "https://api.seatgeek.com/2/venues"
        case .clientID:
            return "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5"
        }
    }
}

