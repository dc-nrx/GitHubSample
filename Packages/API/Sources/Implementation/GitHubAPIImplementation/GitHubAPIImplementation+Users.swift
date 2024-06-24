//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API

extension GitHubAPIImplementation: GithubUsersAPI {
    
    public func fetchUsers(since: User.ID, perPage: Int) async throws -> ([User], UrlPaginationInfo) {
        let url = try URL(base: baseURL, path: "users", query: [
            "since": since,
            "per_page": perPage
        ])
        return try await fetchUsers(url: url)
    }
    
    public func fetchUsers(pageToken: URL) async throws -> ([User], UrlPaginationInfo) {
        try await fetchUsers(url: pageToken)
    }
}

private extension GitHubAPIImplementation {
    
    func fetchUsers(url: URL) async throws -> ([User], UrlPaginationInfo) {
        logger.info("requested fetchUsers with \(url)")
        
        let request = makeRequest(.get, for: url)
        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidServerResponse(response)
        }
        guard (200..<400).contains(httpResponse.statusCode) else {
            throw ApiError.httpError(httpResponse.statusCode)
        }
        guard let linkHeader = httpResponse.value(forHTTPHeaderField: "link") else {
            throw ApiError.failedToRetrievePaginationInfoHeader(httpResponse)
        }
        
        //TODO: ensure bg thread on parse
        let usersList = try makeDecoder().decode([User].self, from: data)
        let paginationInfo = try UrlPaginationInfo(githubLinkHeader: linkHeader)
        
        logger.info("fetchUsers for \(url) succeeded")
        return (usersList, paginationInfo)
    }
}
