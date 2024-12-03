//
//  MoviesNetworkServiceProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

protocol MoviesNetworkServiceProtocol {
    var isConnectedPublisher: Published<Bool>.Publisher { get }
    func getPopularMovies(page: Int) async throws -> APIMovies
    func searchMovies(query: String, page: Int) async throws -> APIMovies
    func getMovieDetails(id: Int) async throws -> APIMovieDetails
    func getMovieVideos(id: Int) async throws -> APIVideos
    func getGenres() async throws -> APIGenres
    func getTotalPages(query: String) async throws -> Int
}
