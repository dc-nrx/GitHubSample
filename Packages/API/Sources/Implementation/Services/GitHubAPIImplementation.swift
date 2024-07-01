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
        
    public lazy var users: UsersUrlPaginator = .init(baseURL: baseURL, sessionManager: sessionManager)
    public lazy var repos: UserReposUrlPaginator = .init(baseURL: baseURL, sessionManager: sessionManager)
    
    private let baseURL: URL
    private let sessionManager: SessionManager
    private let logger = Logger(subsystem: "Implementation", category: "GitHubAPIImplementation")
    
    public init(
        baseURL: URL = URL(string: "https://api.github.com")!,
        sessionManager: SessionManager
    ) {
        self.baseURL = baseURL
        self.sessionManager = sessionManager
    }
}

// MARK: - Direct API Calls
public extension GitHubAPIImplementation {
    
    func userDetails(_ username: String) async throws -> User {
        guard !username.isEmpty else {
            throw ApiError.cantBeEmpty("username")
        }

        let url = try URL(base: baseURL, path: "users/\(username)", query: [:])
        let (data, _) = try await sessionManager.data(.get, from: url)
        
        return try JSONDecoder(keyStrategy: .convertFromSnakeCase)
            .decode(User.self, from: data)
    }

}
