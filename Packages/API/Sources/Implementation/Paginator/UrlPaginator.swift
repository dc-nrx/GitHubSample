//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import OSLog

import API

public class UrlPaginator<Item: Decodable & Identifiable> {
    public typealias PaginationInfo = UrlPaginationInfo

    let baseURL: URL
    
    private let sessionManager: SessionManager
    private let logger = Logger(subsystem: "Implementation", category: "UrlPaginator<\(Item.self)>")
    
    public init(baseURL: URL, sessionManager: SessionManager) {
        self.baseURL = baseURL
        self.sessionManager = sessionManager
    }
}

extension UrlPaginator: Paginator {
    
    public func fetch(since: Item.ID, perPage: Int) async throws -> ([Item], PaginationInfo) {

        let url = try URL(base: baseURL, path: "users", query: [
            "since": since,
            "per_page": perPage
        ])
        return try await fetchPage(url: url)
    }
    
    public func fetch(pageToken: URL) async throws -> ([Item], PaginationInfo) {
        try await fetchPage(url: pageToken)
    }
}

private extension UrlPaginator {
    
    func fetchPage(url: URL) async throws -> ([Item], PaginationInfo) {
        logger.debug("requested fetchPage with \(url)")
        
        let (data, response) = try await sessionManager.data(.get, from: url)
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
        let items = try JSONDecoder(keyStrategy: .convertFromSnakeCase)
            .decode([Item].self, from: data)
        let paginationInfo = try PaginationInfo(githubLinkHeader: linkHeader)
        
        logger.debug("fetchPage for \(url) succeeded")
        return (items, paginationInfo)
    }
}
