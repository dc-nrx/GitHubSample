//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API

extension GitHubAPIImplementation: UsersPaginator {
    public typealias PaginationInfo = UrlPaginationInfo
    
    public func fetch(since: User.ID, perPage: Int) async throws -> ([User], PaginationInfo) {
        let url = try URL(base: baseURL, path: "users", query: [
            "since": since,
            "per_page": perPage
        ])
        return try await fetchUsers(url: url)
    }
    
    public func fetch(pageToken: URL) async throws -> ([User], PaginationInfo) {
        try await fetchUsers(url: pageToken)
    }
}

private extension GitHubAPIImplementation {
    
    func fetchUsers(url: URL) async throws -> ([User], PaginationInfo) {
        logger.debug("requested fetchUsers with \(url)")
        
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
        let paginationInfo = try PaginationInfo(githubLinkHeader: linkHeader)
        
        logger.debug("fetchUsers for \(url) succeeded")
        return (usersList, paginationInfo)
    }
}
