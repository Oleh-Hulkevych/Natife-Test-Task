//
//  MoviesNetworkService.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

final class MoviesNetworkService: MoviesNetworkServiceProtocol {

    var isConnectedPublisher: Published<Bool>.Publisher {
        return networkService.isConnectedPublisher
    }
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPopularMovies(page: Int) async throws -> APIMovies {
        try await networkService.request(MoviesEndpoint.popular(page: page))
    }
    
    func searchMovies(query: String, page: Int) async throws -> APIMovies {
        try await networkService.request(MoviesEndpoint.search(query: query, page: page))
    }
    
    func getMovieDetails(id: Int) async throws -> APIMovieDetails {
        try await networkService.request(MoviesEndpoint.details(movieId: id))
    }
    
    func getMovieVideos(id: Int) async throws -> APIVideos {
        try await networkService.request(MoviesEndpoint.videos(movieId: id))
    }
    
    func getGenres() async throws -> APIGenres {
        try await networkService.request(MoviesEndpoint.genres)
    }
    
    func getTotalPages(query: String) async throws -> Int {
        let response = try await searchMovies(query: query, page: 1)
        return response.totalPages
    }
}
