//
//  APIVideo.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

struct APIVideo: Codable {
    let publishedAt: String
    let site: String
    let type: String
    let key: String

    enum CodingKeys: String, CodingKey {
        case publishedAt = "published_at"
        case site
        case type
        case key
    }
}
