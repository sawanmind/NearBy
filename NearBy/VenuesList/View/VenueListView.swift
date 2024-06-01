//
//  VenueListView.swift
//  NearBy
//
//  Created by Sawan Kumar on 01/06/24.
//

import SwiftUI

struct VenueListView: View {
    @StateObject private var viewModel = VenuesViewModel()
    @State private var isSearchActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchQuery, isEditing: $isSearchActive)
                    .padding()
                
                if viewModel.isLoading && viewModel.filteredVenues.isEmpty {
                    Spacer()
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.filteredVenues) { venue in
                            VStack(alignment: .leading) {
                                Text(venue.name ?? "")
                                    .font(.headline)
                                Text(venue.city ?? "")
                                Text(venue.address ?? "")
                            }
                            .onTapGesture {
                                if let url = URL(string: venue.url ?? "") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                
                                ProgressView()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                
                                Spacer()
                            }
                        } else if viewModel.canLoadMorePages && !isSearchActive {
                            Color.clear
                                .onAppear {
                                    viewModel.loadNextPage()
                                }
                        }
                    }
                }
                
                Spacer()
                
                Slider(value: $viewModel.distanceFilter, in: 1...100, step: 1)
                    .padding()
                Text("Within: \(Int(viewModel.distanceFilter)) km of current location")
                    .padding()
            }
            .navigationTitle("Nearby Venues")
            .onAppear {
                viewModel.requestLocation()
            }
        }
    }
}

