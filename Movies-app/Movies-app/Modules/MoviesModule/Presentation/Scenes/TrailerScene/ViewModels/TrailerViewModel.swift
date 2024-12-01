//
//  TrailerViewModel.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

protocol TrailerViewModelProtocol { }

final class TrailerViewModel: TrailerViewModelProtocol {
    
    private let videoURL: String
    
    init(videoURL: String) {
        self.videoURL = videoURL
    }
}
