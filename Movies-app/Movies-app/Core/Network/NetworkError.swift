//
//  NetworkError.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    
    case noData
    case noConnection
    case requestFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    case invalidData
    case invalidURL
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .noData:
            return LocalizedKey.networkErrorNoData.localizedString
        case .noConnection:
            return LocalizedKey.networkErrorNoConnection.localizedString
        case let .requestFailed(underlyingError: underlyingError):
            return LocalizedKey.networkErrorRequestFailed.localizedString + "\(underlyingError.localizedDescription)"
        case .invalidData:
            return LocalizedKey.networkErrorInvalidData.localizedString
        case .invalidURL:
            return LocalizedKey.networkErrorInvalidURL.localizedString
        case .unauthorized:
            return LocalizedKey.networkErrorUnauthorized.localizedString
        case let .decodingFailed(underlyingError: underlyingError):
            return LocalizedKey.networkErrorDecodingFailed.localizedString + "\(underlyingError.localizedDescription)"
        }
    }
}
