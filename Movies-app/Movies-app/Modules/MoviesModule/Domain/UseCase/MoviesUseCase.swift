//
//  MoviesUseCase.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

final class MoviesUseCase: MoviesUseCaseProtocol {
    
    var isConnectedPublisher: Published<Bool>.Publisher {
        return repository.isConnectedPublisher
    }
    
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadPopularMovies(page: Int) async throws -> [Movie] {
        try await repository.loadPopularMovies(page: page)
    }
    
    func loadCachedPopularMovies() async -> [Movie] {
        await repository.loadCachedPopularMovies()
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        try await repository.searchMovies(query: query)
    }
    
    func loadMovieDetails(id: Int) async throws -> MovieDetails {
        try await repository.loadMovieDetails(id: id)
    }
    
    func loadLatestTrailerURL(id: Int) async throws -> String? {
        try await repository.loadLatestTrailerURL(id: id)
    }
}
