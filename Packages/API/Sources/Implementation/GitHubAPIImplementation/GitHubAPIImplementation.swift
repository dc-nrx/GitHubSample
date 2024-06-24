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
    
    let session: URLSession
    let baseURL: URL
    let logger = Logger(subsystem: "API", category: "GitHubAPIImplementation")
    let authToken: String
    
    public init(
        baseURL: URL = URL(string: "https://api.github.com")!,
        session: URLSession = .init(configuration: .default),
        authToken: String
    ) {
        self.session = session
        self.baseURL = baseURL
        self.authToken = authToken
    }
}

extension GitHubAPIImplementation {
    
    var commonHeaders: [String: String] {
        [
            GitHubAPIImplementation.authKey: "Bearer \(authToken)",
            "accept": "application/vnd.github+json"
        ]
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
