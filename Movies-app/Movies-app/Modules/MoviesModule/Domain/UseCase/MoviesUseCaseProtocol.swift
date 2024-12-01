//
//  MoviesUseCaseProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

protocol MoviesUseCaseProtocol {
    func fetchPopularMovies(page: Int) async throws -> [Movie]
    func fetchMovieDetails(id: Int) async throws -> MovieDetails
    func searchMovies(query: String, page: Int) async throws -> [Movie]
}
