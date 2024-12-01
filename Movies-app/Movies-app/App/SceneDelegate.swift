//
//  SceneDelegate.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let container = DependencyContainer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        // Here we can implement module switching based on application state
        // For example: authentication status, onboarding completion, etc.
        // For better implementation, consider using AppCoordinator to manage
        // module navigation and handle different application flows.
        let moviesModule = ModuleBuilder.movies(
            controller: navigationController,
            container: container
        )
        moviesModule.coordinator.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

