//
//  MovieDetailsViewModel.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Combine

protocol MovieDetailsViewModelProtocol {
    var state: MoviesDetailsState { get }
    var movieDetailsPublisher: Published<MoviesDetailsState>.Publisher { get }
}

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {

   @Published private(set) var state = MoviesDetailsState()
   var movieDetailsPublisher: Published<MoviesDetailsState>.Publisher { $state }

   private let movieId: Int
   private let useCase: MoviesUseCaseProtocol
   private var cancellables: Set<AnyCancellable> = []
   
   init(
       movieId: Int,
       movieTitle: String,
       useCase: MoviesUseCaseProtocol
   ) {
       self.movieId = movieId
       self.useCase = useCase
       self.state.movieTitle = movieTitle
       
       Task {
           await loadData()
       }
   }
   
    // MARK: Data methods
    
   private func loadData() async {
       await loadMovieDetails()
       await loadTrailerURL()
   }
   
    private func loadMovieDetails() async {
        do {
            state.movieDetails = try await useCase.loadMovieDetails(id: movieId)
        } catch let error as NetworkError {
            state.error = error
        } catch {
            state.error = .requestFailed(underlyingError: error)
        }
    }

    private func loadTrailerURL() async {
        do {
            state.trailerURLString = try await useCase.loadLatestTrailerURL(id: movieId)
        } catch let error as NetworkError {
            state.error = error
        } catch {
            state.error = .requestFailed(underlyingError: error)
        }
    }
}
