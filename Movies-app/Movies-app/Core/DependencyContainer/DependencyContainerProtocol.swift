//
//  DependencyContainerProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

protocol DependencyContainerProtocol {
    var coreDataManager: CoreDataManagerProtocol { get }
    var networkService: NetworkServiceProtocol { get }
}
