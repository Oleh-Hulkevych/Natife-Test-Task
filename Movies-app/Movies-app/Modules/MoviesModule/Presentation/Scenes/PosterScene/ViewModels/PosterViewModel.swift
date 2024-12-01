//
//  PosterViewModel.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

protocol PosterViewModelProtocol { }

final class PosterViewModel: PosterViewModelProtocol {
    
    private let imageURL: String
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
}
