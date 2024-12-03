//
//  MoviesFeedState.swift
//  Movies-app
//
//  Created by Oleh on 01.12.2024.
//

struct MoviesFeedState {
    var movies: [Movie] = []
    var currentPage: Int = 1
    var sortOption: SortOption = .defaultOption
    var searchText: String? = nil
    var loading: MoviesLoadingState = .none
    var userFlow: MoviesFeedUserFlow = .browsing
    var isNetworkConnected: Bool = false
    var error: NetworkError? = nil
}

enum MoviesLoadingState {
    case none
    case initial
    case pagination
    case searching
}

enum MoviesFeedUserFlow {
    case browsing
    case searching
}
