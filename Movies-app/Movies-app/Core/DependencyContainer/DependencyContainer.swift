//
//  DependencyContainer.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

final class DependencyContainer: DependencyContainerProtocol {
    
    let coreDataManager: CoreDataManagerProtocol
    let networkService: NetworkServiceProtocol
    
    init(
        coreDataManager: CoreDataManagerProtocol = CoreDataManager(),
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.coreDataManager = coreDataManager
        self.networkService = networkService
    }
}
