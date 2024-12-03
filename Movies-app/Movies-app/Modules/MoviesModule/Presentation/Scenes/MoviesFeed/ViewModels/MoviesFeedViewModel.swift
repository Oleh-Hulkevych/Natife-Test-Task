//
//  MoviesListViewModel.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation
import Combine

protocol MoviesFeedViewModelProtocol: AnyObject {
    var state: MoviesFeedState { get }
    var statePublisher: Published<MoviesFeedState>.Publisher { get }
    func loadMorePopularMovies()
    func applySorting(_ option: SortOption)
    func refreshMovies()
    func searchMovies(query: String)
    func switchUserFlow(to flow: MoviesFeedUserFlow)
}

final class MoviesFeedViewModel: MoviesFeedViewModelProtocol {

    @Published private(set) var state = MoviesFeedState()
    var statePublisher: Published<MoviesFeedState>.Publisher { $state }
    private var cancellables: Set<AnyCancellable> = []

    private let useCase: MoviesUseCaseProtocol

    init(useCase: MoviesUseCaseProtocol) {
        self.useCase = useCase
        setupNetworkConnectionObserver()
        loadPopularMovies()
    }
    
    // MARK: Observers
    
    private func setupNetworkConnectionObserver() {
        useCase.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                self.updateState { $0.isNetworkConnected = isConnected }
            }
            .store(in: &cancellables)
    }
    
    // MARK: Data methods
    
    private func loadPopularMovies() {
        guard case .none = state.loading else { return }
        updateState { $0.loading = .initial }
        performMoviesOperation(with: .browsing) { [weak self] in
            guard let self else { return [] }
            let pageNumber = self.state.currentPage
            return try await self.useCase.loadPopularMovies(
                page: pageNumber
            )
        }
    }
    
    func loadMorePopularMovies() {
        guard case .none = state.loading else { return }
        updateState {
            $0.loading = .pagination
            $0.currentPage += 1
        }
        performMoviesOperation(with: .browsing) { [weak self] in
            guard let self else { return [] }
            let pageNumber = self.state.currentPage
            let newMovies = try await self.useCase.loadPopularMovies(page: pageNumber)
            self.updateState { state in
                state.currentPage = newMovies.isEmpty ? 1 : pageNumber
            }
            return newMovies
        }
    }
    
    func searchMovies(query: String) {
        guard case .none = state.loading else { return }
        updateState { $0.loading = .searching }
        performMoviesOperation(with: .searching) { [weak self] in
            guard let self else { return [] }
            return try await self.useCase.searchMovies(query: query)
        }
    }
    
    // MARK: Sorting methods
    
    func applySorting(_ option: SortOption) {
        Task {
            let movies = await sortMovies(by: option)
            updateState {
                $0.sortOption = option
                $0.movies = movies
            }
        }
    }

    private func sortMovies(by option: SortOption) async -> [Movie] {
        switch option {
        case .defaultOption:
            return await useCase.loadCachedPopularMovies()
        case let sortOption:
            return state.movies.sorted(by: sortOption)
        }
    }
    
    func switchUserFlow(to flow: MoviesFeedUserFlow) {
        updateState { $0.userFlow = flow }
    }

    func refreshMovies() {
        updateState {
            $0.sortOption = .defaultOption
            $0.currentPage = 1
            $0.searchText = nil
            $0.error = nil
        }
        loadPopularMovies()
    }
    
    // MARK: Private Methods
    
    private func performMoviesOperation(with flow: MoviesFeedUserFlow, _ operation: @escaping () async throws -> [Movie]) {
        Task {
            do {
                let movies = try await operation()
                handleSuccess(movies, userFlow: flow)
                updateState { $0.loading = .none }
            } catch let error as NetworkError {
                updateState {
                    $0.error = error
                    $0.loading = .none
                }
            }
        }
    }

    private func handleSuccess(_ movies: [Movie], userFlow: MoviesFeedUserFlow) {
       updateState {
           switch userFlow {
           case .browsing:
               let sortedMovies = movies.sorted(by: $0.sortOption)
               if $0.currentPage == 1 {
                   $0.movies = sortedMovies
               } else {
                   $0.movies.append(contentsOf: sortedMovies)
               }
               
           case .searching:
               $0.movies = movies
           }
       }
    }
    
    private func updateState(_ update: (inout MoviesFeedState) -> Void) {
        var newState = state
        update(&newState)
        state = newState
    }
}
