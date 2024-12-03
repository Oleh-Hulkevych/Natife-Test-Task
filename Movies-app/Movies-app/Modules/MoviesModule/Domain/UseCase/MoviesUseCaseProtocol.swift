//
//  MoviesUseCaseProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Combine

protocol MoviesUseCaseProtocol {
    var isConnectedPublisher: Published<Bool>.Publisher { get }
    func loadPopularMovies(page: Int) async throws -> [Movie]
    func loadCachedPopularMovies() async -> [Movie]
    func loadMovieDetails(id: Int) async throws -> MovieDetails
    func searchMovies(query: String) async throws -> [Movie]
}
