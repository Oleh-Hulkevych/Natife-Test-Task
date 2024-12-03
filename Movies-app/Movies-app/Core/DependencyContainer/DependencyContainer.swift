//
//  DependencyContainer.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

final class DependencyContainer: DependencyContainerProtocol {
    
    let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
}
