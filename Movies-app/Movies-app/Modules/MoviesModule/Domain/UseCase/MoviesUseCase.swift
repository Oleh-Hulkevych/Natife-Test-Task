//
//  MoviesUseCase.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

final class MoviesUseCase: MoviesUseCaseProtocol {
    
    private let repository: MoviesRepositoryProtocol
    
    init(repository: MoviesRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        try await repository.fetchPopularMovies(page: page)
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        try await repository.fetchMovieDetails(id: id)
    }
    
    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return try await fetchPopularMovies(page: page)
        }
        
        return try await repository.searchMovies(query: query, page: page)
    }
}
