//
//  VenuesViewModel.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import Foundation
import Combine

final class VenuesViewModel: ObservableObject {
    @Published var venues: [Venue] = []
    @Published var filteredVenues: [Venue] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var distanceFilter: Double = 5.0 {
        didSet {
            if let location = self.location {
                self.fetchVenues(latitude: location.latitude, longitude: location.longitude, reset: true)
            }
        }
    }
    
    @Published var searchQuery: String = "" {
        didSet {
            filterVenues()
        }
    }
    
    private let venueService: VenueServiceProtocol
    private let cacheService: CacheService
    private var cancellables = Set<AnyCancellable>()
    
    private var locationService: LocationService?
    var location: Location?
    
    private var currentPage = 1
    private(set) var canLoadMorePages = true
    
    
    init(venueService: VenueServiceProtocol = VenueService(), cacheService: CacheService = CacheService()) {
        self.venueService = venueService
        self.cacheService = cacheService
        
        do {
            if let cachedVenues = try cacheService.loadCachedVenues() {
                self.venues = cachedVenues
                self.filteredVenues = cachedVenues
            }
        } catch {
            // Here we are not showing cache error to user. In case of this we will fetch data from server
            print("Failed to load cached venues: \(error.localizedDescription)")
        }
        
        setupLocationManager()
    }
    
    private func setupLocationManager(){
        let locationManager = LocationCoreManager()
        locationService = LocationService(locationManager: locationManager)
    }
    
    private func filterVenues() {
        if searchQuery.isEmpty {
            filteredVenues = venues
        } else {
            filteredVenues = venues.filter { $0.name?.lowercased().contains(searchQuery.lowercased()) ?? false }
        }
    }
    
    func fetchVenues(latitude: Double, longitude: Double, page: Int = 1, reset: Bool = false) {
        if isLoading || !canLoadMorePages {
            return
        }
        
        if reset {
            currentPage = 1
            canLoadMorePages = true
            venues = []
            filteredVenues = []
        }
        
        isLoading = true
        errorMessage = nil
      
        venueService.fetchVenues(lat: latitude, lon: longitude, range: "\(Int(distanceFilter))mi", page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.errorDescription
                }
            } receiveValue: { [weak self] venues in
                guard let self = self else { return }
                if reset {
                    self.venues = venues
                } else {
                    self.venues.append(contentsOf: venues)
                }
                self.filterVenues()
                self.canLoadMorePages = !venues.isEmpty
                self.currentPage += 1
                do {
                    try self.cacheService.saveVenuesToCache(self.venues)
                } catch {
                    print("Failed to save venues to cache: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        if let location = self.location {
            fetchVenues(latitude: location.latitude, longitude: location.longitude, page: currentPage)
        }
    }
    
    func requestLocation() {
        locationService?.fetchCurrentLocation(delegate: self)
    }
    
}

extension VenuesViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: Location) {
        self.location = location
        self.fetchVenues(latitude: location.latitude, longitude: location.longitude)
    }
    
    func didFailWithError(_ error: LocationError) {
        self.errorMessage = error.errorDescription
    }
}

