//
//  CacheService.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation

class CacheService {
    private let cacheFileName = "cachedVenues.json"
    
    func saveVenuesToCache(_ venues: [Venue]) throws {
        do {
            let fileURL = try getCacheFileURL()
            let data = try JSONEncoder().encode(venues)
            try data.write(to: fileURL)
        } catch {
            throw CacheError.saveFailed(error)
        }
    }
    
    func loadCachedVenues() throws -> [Venue]? {
        do {
            let fileURL = try getCacheFileURL()
            let data = try Data(contentsOf: fileURL)
            let venues = try JSONDecoder().decode([Venue].self, from: data)
            return venues
        } catch let error as NSError where error.code == NSFileReadNoSuchFileError {
            throw CacheError.fileNotFound
        } catch {
            throw CacheError.loadFailed(error)
        }
    }
    
    private func getCacheFileURL() throws -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw CacheError.fileNotFound
        }
        return documentsDirectory.appendingPathComponent(cacheFileName)
    }
}

