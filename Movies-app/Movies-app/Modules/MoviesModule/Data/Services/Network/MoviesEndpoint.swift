//
//  MoviesEndpoint.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation
import Alamofire

enum MoviesEndpoint: EndpointProtocol {
    case popular(page: Int)
    case search(query: String, page: Int)
    case details(movieId: Int)
    case videos(movieId: Int)
    case genres
    
    var baseURL: String {
        APIConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .popular:
            return "movie/popular"
        case .search:
            return "search/movie"
        case let .details(movieId):
            return "movie/\(movieId)"
        case let .videos(movieId):
            return "movie/\(movieId)/videos"
        case .genres:
            return "genre/movie/list"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "api_key": APIConstants.apiKey,
            "language": Locale.current.languageCode ?? "en"
        ]
        
        switch self {
        case let .popular(page):
            params["page"] = page
        case let .search(query, page):
            params["query"] = query
            params["page"] = page
        case .details, .genres, .videos:
            break
        }
        
        return params
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
