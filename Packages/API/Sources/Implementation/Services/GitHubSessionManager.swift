//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API
import OSLog

public class GitHubAPIImplementation: GitHubAPI {
    public typealias PaginationInfo = UrlPaginationInfo
        
    public var users: UsersUrlPaginator
    public var repos: UserReposUrlPaginator
    
    init(
        users: UsersUrlPaginator,
        repos: UserReposUrlPaginator
    ) {
        self.users = users
        self.repos = repos
    }
}

public class GitHubSessionManager {
    public static let authKey = "Authorization"
    
    public var authToken: String?    
    
    let logger = Logger(subsystem: "API", category: "GitHubAPIImplementation")
    
    private let session: URLSession
    private let rateLimiter: RateLimiter
    
    public init(
        session: URLSession = .init(configuration: .default),
        rateLimiter: RateLimiter = .init(),
        authToken: String? = nil
    ) {
        self.session = session
        self.authToken = authToken
        self.rateLimiter = rateLimiter
    }
}

extension GitHubSessionManager: SessionManager {
       
    public func data(_ method: HttpMethod, from url: URL) async throws -> (Data, URLResponse) {
        try await rateLimiter.record(ignoreLimitExceededCheck: ignoreRateLimit)
        let request = makeRequest(method, for: url)
        return try await session.data(for: request)
    }
}

private extension GitHubSessionManager {
    
    var commonHeaders: [String: String] {
        var result = [
            "accept": "application/vnd.github+json"
        ]
        if let authToken {
            result[GitHubSessionManager.authKey] = "Bearer \(authToken)"
        }
        return result
    }

    var ignoreRateLimit: Bool {
        authToken != nil
    }
    
    func makeRequest(_ method: HttpMethod, for url: URL) -> URLRequest {
        var result = URLRequest(url: url)
        result.allHTTPHeaderFields = commonHeaders
        result.httpMethod = method.rawValue
        return result
    }
}
