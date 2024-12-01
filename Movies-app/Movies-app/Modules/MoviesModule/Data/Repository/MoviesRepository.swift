//
//  MoviesRepository.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import Foundation

protocol MoviesRepositoryProtocol {
    func fetchPopularMovies(page: Int) async throws -> [Movie]
    func fetchMovieDetails(id: Int) async throws -> MovieDetails
    func searchMovies(query: String, page: Int) async throws -> [Movie]
}

final class MoviesRepository: MoviesRepositoryProtocol {
    
    private let networkService: MoviesNetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(
        networkService: MoviesNetworkServiceProtocol,
        storageService: StorageServiceProtocol
    ) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
       do {
           let apiMoviesResponse = try await networkService.getPopularMovies(page: page)
           let genresResponse = try await networkService.getGenres()
           
           let movies = apiMoviesResponse.movies.map {
               Movie(from: $0, genres: genresResponse.genres)
           }
           try await storageService.saveMovies(movies)
           return movies
       } catch NetworkError.noConnection {
           return try await storageService.fetchMovies()
       } catch {
           throw error
       }
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        do {
            let apiDetails = try await networkService.getMovieDetails(id: id)
            let details = MovieDetails(from: apiDetails)
            return details
        } catch NetworkError.noConnection {
            throw NetworkError.noData
        } catch {
            throw error
        }
    }

    func searchMovies(query: String, page: Int) async throws -> [Movie] {
       do {
           let apiMoviesResponse = try await networkService.searchMovies(query: query, page: page)
           let genresResponse = try await networkService.getGenres()
           
           let movies = apiMoviesResponse.movies.map {
               Movie(from: $0, genres: genresResponse.genres)
           }
           return movies
       } catch NetworkError.noConnection {
           return try await storageService.searchMovies(query: query)
       } catch {
           throw error
       }
    }
}
