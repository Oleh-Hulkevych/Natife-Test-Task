//
//  NetworkService.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T
    var isConnected: Bool { get }
    var networkError: NetworkError? { get }
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: Session
    private let reachabilityManager: NetworkReachabilityManager?
    
    @Published private(set) var networkError: NetworkError?
    
    init(session: Session = .default) {
        self.session = session
        self.reachabilityManager = NetworkReachabilityManager.default
        setupReachabilityManager()
    }
    
    var isConnected: Bool {
        reachabilityManager?.isReachable ?? false
    }
    
    private func setupReachabilityManager() {
        reachabilityManager?.startListening { [weak self] status in
            guard let self else { return }
            switch status {
            case .reachable(let connectionType):
                switch connectionType {
                case .ethernetOrWiFi, .cellular:
                    self.networkError = nil
                }
            case .notReachable, .unknown:
                self.networkError = .noConnection
            }
        }
    }
    
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
        guard isConnected else {
            throw NetworkError.noConnection
        }
        
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                headers: endpoint.headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401, 403:
                            continuation.resume(throwing: NetworkError.unauthorized)
                        case 404:
                            continuation.resume(throwing: NetworkError.noData)
                        case 500...599:
                            continuation.resume(throwing: NetworkError.requestFailed(underlyingError: error))
                        default:
                            if let decodingError = error.underlyingError as? DecodingError {
                                continuation.resume(throwing: NetworkError.decodingFailed(underlyingError: decodingError))
                            } else {
                                continuation.resume(throwing: NetworkError.requestFailed(underlyingError: error))
                            }
                        }
                    } else {
                        continuation.resume(throwing: NetworkError.noData)
                    }
                }
            }
        }
    }
}
