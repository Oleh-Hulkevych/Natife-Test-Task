//
//  MoviesRepository.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import Combine

protocol MoviesRepositoryProtocol {
    var isConnectedPublisher: Published<Bool>.Publisher { get }
    func loadPopularMovies(page: Int) async throws -> [Movie]
    func loadCachedPopularMovies() async -> [Movie]
    func loadMovieDetails(id: Int) async throws -> MovieDetails
    func searchMovies(query: String) async throws -> [Movie]
}

final class MoviesRepository: MoviesRepositoryProtocol {
    
    @Published private var isConnected: Bool = false
    
    private var cachedPopularMovies: [Movie] = []
    var isConnectedPublisher: Published<Bool>.Publisher {
        networkService.isConnectedPublisher
    }
    private var cancellables = Set<AnyCancellable>()
    
    private let networkService: MoviesNetworkServiceProtocol
    
    init(
        networkService: MoviesNetworkServiceProtocol
    ) {
        self.networkService = networkService
        setupNetworkConnectionObserver()
    }
    
    private func setupNetworkConnectionObserver() {
        networkService.isConnectedPublisher
            .assign(to: \.isConnected, on: self)
            .store(in: &cancellables)
    }
}

// MARK: Loading methods

extension MoviesRepository {
    
    func loadPopularMovies(page: Int) async throws -> [Movie] {
       if isConnected {
           return try await performOnlineLoading(page: page)
       } else {
           return performOfflineLoading()
       }
    }

    private func performOnlineLoading(page: Int) async throws -> [Movie] {
       do {
           let apiMoviesResponse = try await networkService.getPopularMovies(page: page)
           let genresResponse = try await networkService.getGenres()
           let movies = apiMoviesResponse.movies.map {
               Movie(from: $0, genres: genresResponse.genres)
           }
           appendNewMoviesToCache(movies)
           return movies
       } catch let error as NetworkError {
           throw error
       }
    }

    private func performOfflineLoading() -> [Movie] {
       return cachedPopularMovies
    }

    private func appendNewMoviesToCache(_ newMovies: [Movie]) {
       for movie in newMovies {
           if !cachedPopularMovies.contains(where: { $0.id == movie.id }) {
               cachedPopularMovies.append(movie)
           }
       }
    }

    func loadCachedPopularMovies() async -> [Movie] {
        cachedPopularMovies
    }
    
    func loadMovieDetails(id: Int) async throws -> MovieDetails {
        do {
            let apiDetails = try await networkService.getMovieDetails(id: id)
            let details = MovieDetails(from: apiDetails)
            return details
        } catch let error as NetworkError {
            throw error
        }
    }
}

// MARK: Searching methods

extension MoviesRepository {
    
    func searchMovies(query: String) async throws -> [Movie] {
       if isConnected {
           return try await performOnlineSearch(query: query)
       } else {
           return performOfflineSearch(query: query)
       }
    }
    
    private func performOnlineSearch(query: String) async throws -> [Movie] {
       do {
           let totalPages = try await networkService.getTotalPages(query: query)
           var allMovies: [Movie] = []
           let maxPages = min(totalPages, 5)
           
           for page in 1...maxPages {
               let apiMoviesResponse = try await networkService.searchMovies(query: query, page: page)
               let genresResponse = try await networkService.getGenres()
               
               let movies = apiMoviesResponse.movies.map {
                   Movie(from: $0, genres: genresResponse.genres)
               }
               
               allMovies.append(contentsOf: movies)
           }
           
           return allMovies
       } catch let error as NetworkError {
           throw error
       }
    }

    private func performOfflineSearch(query: String) -> [Movie] {
       let lowercasedQuery = query.lowercased()
       return cachedPopularMovies.filter { movie in
           movie.title.lowercased().contains(lowercasedQuery)
       }
    }
}
