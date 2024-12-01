//
//  MoviesModule.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import UIKit

protocol MoviesModuleProtocol {
   var coordinator: MoviesCoordinator { get }
}

final class MoviesModule: MoviesModuleProtocol {
    
   let coordinator: MoviesCoordinator
   
   private init(coordinator: MoviesCoordinator) {
       self.coordinator = coordinator
   }
   
   static func build(
       navigationController: UINavigationController,
       container: DependencyContainerProtocol
   ) -> MoviesModule {
       
       let storageService = StorageService(coreDataManager: container.coreDataManager)
       let moviesNetworkService = MoviesNetworkService(networkService: container.networkService)
       let repository = MoviesRepository(
           networkService: moviesNetworkService,
           storageService: storageService
       )

       let useCase = MoviesUseCase(repository: repository)
       let factory = MoviesFactory(useCase: useCase)
       let coordinator = MoviesCoordinator(
           navigationController: navigationController,
           factory: factory
       )
       
       return MoviesModule(coordinator: coordinator)
   }
}
