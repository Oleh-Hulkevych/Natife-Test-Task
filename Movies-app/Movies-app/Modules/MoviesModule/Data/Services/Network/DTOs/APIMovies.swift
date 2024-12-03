//
//  APIMovies.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

struct APIMovies: Decodable {
    let movies: [APIMovie]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
    }
}
