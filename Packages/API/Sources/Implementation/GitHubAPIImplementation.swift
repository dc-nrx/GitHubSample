//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API
import OSLog

public enum ApiError: Error {
    case failedToRetrievePaginationInfoHeader(HTTPURLResponse)
    case invalidServerResponse(URLResponse)
    case httpError(Int)
}

public class GitHubAPIImplementation {
    
    private let session: URLSession
    private let baseURL: URL
    private let logger = Logger(subsystem: "API", category: "GitHubAPIImplementation")
    
    public init(
        baseURL: URL = URL(string: "https://api.github.com")!,
        session: URLSession = .shared
    ) throws {
        self.session = session
        self.baseURL = baseURL
    }
}

extension GitHubAPIImplementation: GitHubAPI {
    public typealias PaginationInfo = UrlPaginationInfo

    public func fetchUsers(since: User.ID, perPage: Int) async throws -> ([User], UrlPaginationInfo) {
        let url = baseURL.appending(path: "/users")
        return try await fetchUsers(url: url)
    }
    
    public func fetchUsers(pageToken: URL) async throws -> ([User], UrlPaginationInfo) {
        try await fetchUsers(url: pageToken)
    }
}

private extension GitHubAPIImplementation {
    
    func fetchUsers(url: URL) async throws -> ([User], UrlPaginationInfo) {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidServerResponse(response)
        }
        guard (200..<400).contains(httpResponse.statusCode) else {
            throw ApiError.httpError(httpResponse.statusCode)
        }
        guard let linkHeader = httpResponse.allHeaderFields["link"] as? String else {
            throw ApiError.failedToRetrievePaginationInfoHeader(httpResponse)
        }
        
        //TODO: ensure bg thread on parse
        let usersList = try makeDecoder().decode([User].self, from: data)
        let paginationInfo = try UrlPaginationInfo(githubLinkHeader: linkHeader)
        return (usersList, paginationInfo)
    }
        
    
    func makeDecoder() -> JSONDecoder {
        .init(keyStrategy: .convertFromSnakeCase)
    }
}
