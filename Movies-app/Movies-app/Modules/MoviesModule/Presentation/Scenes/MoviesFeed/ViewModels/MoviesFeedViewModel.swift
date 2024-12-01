//
//  MoviesListViewModel.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

protocol MoviesFeedViewModelProtocol: ObservableObject {
    
    // State Publishers
    var moviesPublisher: Published<[Movie]>.Publisher { get }
    var errorPublisher: Published<NetworkError?>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    
    // Current State
    var currentMovies: [Movie] { get }
    
    // User Actions
    func fetchMovies() async
    func searchMovies(query: String) async
    func loadMoreIfNeeded(currentItem: Movie)
    func applySorting(_ option: SortOption)
    func refreshData() async
}

final class MoviesFeedViewModel: MoviesFeedViewModelProtocol {
    
    // MARK: Published Properties
    @Published private var movies: [Movie] = []
    @Published private var error: NetworkError?
    @Published private var isLoading = false
    @Published private var sortOption: SortOption = .defaultOption
    
    // MARK: Published Publishers (Protocol Conformance)
    var moviesPublisher: Published<[Movie]>.Publisher { $movies }
    var errorPublisher: Published<NetworkError?>.Publisher { $error }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    
    var currentMovies: [Movie] {
            movies
        }
    
    // MARK: Private Properties
    private var currentPage = 1
    private var hasReachedEnd = false
    private var searchQuery: String?
    
    // MARK: Dependencies & initialization
    private let useCase: MoviesUseCaseProtocol

    init(useCase: MoviesUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: Protocol Methods
    func fetchMovies() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            let newMovies = try await useCase.fetchPopularMovies(page: currentPage)
            if !newMovies.isEmpty {
                movies.append(contentsOf: sortOption == .defaultOption ? newMovies : sortMovies(newMovies))
            }
            hasReachedEnd = newMovies.isEmpty
        } catch let networkError as NetworkError {
            self.error = networkError
        } catch {
            self.error = .requestFailed(underlyingError: error)
        }

        isLoading = false
    }
    
    func searchMovies(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchQuery = nil
            currentPage = 1
            await fetchMovies()
            return
        }
        
        guard !isLoading else { return }
        isLoading = true
        error = nil
        searchQuery = query
        currentPage = 1
        
        do {
            let searchResults = try await useCase.searchMovies(query: query, page: currentPage)
            movies = sortOption == .defaultOption ? searchResults : sortMovies(searchResults)
            hasReachedEnd = searchResults.isEmpty
        } catch let networkError as NetworkError {
            self.error = networkError
        } catch {
            self.error = .requestFailed(underlyingError: error)
        }
        
        isLoading = false
    }
    
    func loadMoreIfNeeded(currentItem: Movie) {
        guard let lastMovie = movies.last,
              lastMovie.id == currentItem.id,
              !isLoading,
              !hasReachedEnd else {
            return
        }
        
        currentPage += 1
        Task {
            if let query = searchQuery {
                await searchMovies(query: query)
            } else {
                await fetchMovies()
            }
        }
    }
    
    func applySorting(_ option: SortOption) {
        sortOption = option
        movies = sortMovies(movies)
    }
    
    func refreshData() async {
        currentPage = 1
        hasReachedEnd = false
        if let query = searchQuery {
            await searchMovies(query: query)
        } else {
            await fetchMovies()
        }
    }
    
    // MARK: - Private Methods
    private func sortMovies(_ movies: [Movie]) -> [Movie] {
        switch sortOption {
        case .nameAscending:
            return movies.sorted { $0.title < $1.title }
        case .nameDescending:
            return movies.sorted { $0.title > $1.title }
        case .yearAscending:
            return movies.sorted { $0.year < $1.year }
        case .yearDescending:
            return movies.sorted { $0.year > $1.year }
        case .ratingAscending:
            return movies.sorted { $0.rating < $1.rating }
        case .ratingDescending:
            return movies.sorted { $0.rating > $1.rating }
        case .votesAscending:
            return movies.sorted { $0.votes < $1.votes }
        case .votesDescending:
            return movies.sorted { $0.votes > $1.votes }
        case .defaultOption:
            return movies
        }
    }
}
