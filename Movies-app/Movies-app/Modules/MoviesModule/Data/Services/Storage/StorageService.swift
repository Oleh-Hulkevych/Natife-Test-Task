//
//  StorageService.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

final class StorageService: StorageServiceProtocol {
    
   private let coreDataManager: CoreDataManagerProtocol
   
   init(coreDataManager: CoreDataManagerProtocol) {
       self.coreDataManager = coreDataManager
   }
   
   func saveMovies(_ movies: [Movie]) async throws {
   }
   
   func fetchMovies() async throws -> [Movie] {
       return []
   }
   
   func searchMovies(query: String) async throws -> [Movie] {
       return []
   }
}
