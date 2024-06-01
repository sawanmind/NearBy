//
//  VenuesViewModel.swift
//  NearByTests
//
//  Created by Sawan Kumar on 01/06/24.
//

import XCTest
@testable import NearBy

final class VenuesViewModelTest: XCTestCase {
    
    var viewModel: VenuesViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = VenuesViewModel(venueService: MockVenueService(), cacheService: MockCacheService())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchVenues() {
        let expectation = XCTestExpectation(description: "Fetching venues")
        viewModel.location = Location(latitude: 0, longitude: 0)
        
        viewModel.fetchVenues(latitude: 0, longitude: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.viewModel.venues.isEmpty)
            XCTAssertFalse(self.viewModel.filteredVenues.isEmpty)
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertTrue(self.viewModel.isLoading == false)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFilterVenues() {
        viewModel.venues = [
            Venue(id: 1, name: "Venue A", city: nil, address: nil, url: nil),
            Venue(id: 2, name: "Venue B", city: nil, address: nil, url: nil),
            Venue(id: 3, name: "Venue C", city: nil, address: nil, url: nil)
        ]
        
        viewModel.searchQuery = "A"
        
        XCTAssertEqual(viewModel.filteredVenues.count, 1)
        XCTAssertEqual(viewModel.filteredVenues.first?.name, "Venue A")
    }
    
}
