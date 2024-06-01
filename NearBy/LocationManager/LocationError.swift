//
//  LocationError.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation

enum LocationError: Error, LocalizedError {
    case accessNotGiven
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .accessNotGiven:
            return "Location access not given. Please grant access to show nearby venues."
        case .unknownError(let error):
            return "Failed to save data to cache: \(error.localizedDescription)"
        }
    }
}
