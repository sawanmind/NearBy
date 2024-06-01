//
//  CacheError.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation

enum CacheError: Error, LocalizedError {
    case fileNotFound
    case dataCorrupted
    case saveFailed(Error)
    case loadFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Cache file not found."
        case .dataCorrupted:
            return "Cache data is corrupted."
        case .saveFailed(let error):
            return "Failed to save data to cache: \(error.localizedDescription)"
        case .loadFailed(let error):
            return "Failed to load data from cache: \(error.localizedDescription)"
        }
    }
}

