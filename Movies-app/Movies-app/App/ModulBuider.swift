//
//  ModulеBuider.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import UIKit

protocol MoviesModuleBuildingProtocol {
    static func movies(controller: UINavigationController, container: DependencyContainerProtocol) -> MoviesModule
}

enum ModuleBuilder: MoviesModuleBuildingProtocol {
    
    static func movies(controller: UINavigationController, container: DependencyContainerProtocol) -> MoviesModule {
        return MoviesModule.build(
            navigationController: controller,
            container: container
        )
    }
}
