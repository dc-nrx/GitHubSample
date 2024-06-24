//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API
import OSLog

public class GitHubAPIImplementation {
    public typealias PaginationInfo = UrlPaginationInfo
    
    static let authKey = "Authorization"
    
    public var authToken: String?    
    
    let baseURL: URL
    let logger = Logger(subsystem: "API", category: "GitHubAPIImplementation")
    
    private let session: URLSession
    
    public init(
        baseURL: URL = URL(string: "https://api.github.com")!,
        session: URLSession = .init(configuration: .default),
        authToken: String? = nil
    ) {
        self.session = session
        self.baseURL = baseURL
        self.authToken = authToken
    }
}

extension GitHubAPIImplementation {
    
    var commonHeaders: [String: String] {
        var result = [
            "accept": "application/vnd.github+json"
        ]
        if let authToken {
            result[GitHubAPIImplementation.authKey] = "Bearer \(authToken)"
        }
        return result
    }
   
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
    
    func makeRequest(_ method: HttpMethod, for url: URL) -> URLRequest {
        var result = URLRequest(url: url)
        result.allHTTPHeaderFields = commonHeaders
        result.httpMethod = method.rawValue
        return result
    }
    
    func makeDecoder() -> JSONDecoder {
        .init(keyStrategy: .convertFromSnakeCase)
    }
}
