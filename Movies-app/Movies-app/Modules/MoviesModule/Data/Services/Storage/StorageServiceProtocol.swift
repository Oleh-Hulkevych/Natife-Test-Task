//
//  StorageServiceProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

protocol StorageServiceProtocol {
   func saveMovies(_ movies: [Movie]) async throws
   func fetchMovies() async throws -> [Movie]
   func searchMovies(query: String) async throws -> [Movie]
}
