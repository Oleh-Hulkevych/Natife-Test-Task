//
//  EndpointProtocol.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import Alamofire

protocol EndpointProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var baseURL: String { get }
}
