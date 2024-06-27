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
    
    public init(
        baseURL: URL = URL(string: "https://api.github.com")!,
        sessionManager: SessionManager
    ) {
        self.baseURL = baseURL
        self.sessionManager = sessionManager
    }
}

public extension UrlPaginator {
        
    func fetch(pageToken: URL) async throws -> ([Item], PaginationInfo) {
        try await fetchPage(url: pageToken)
    }
}

extension UrlPaginator {
    
    func fetchPage(url: URL) async throws -> ([Item], PaginationInfo) {
        logger.debug("requested fetchPage with \(url)")
        
        let (data, response) = try await sessionManager.data(.get, from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidServerResponse(response)
        }
        guard (200..<400).contains(httpResponse.statusCode) else {
            throw ApiError.httpError(httpResponse.statusCode)
        }
        
        //TODO: ensure bg thread on parse
        let items = try JSONDecoder(keyStrategy: .convertFromSnakeCase)
            .decode([Item].self, from: data)
        
        var paginationInfo: PaginationInfo
        if let linkHeader = httpResponse.value(forHTTPHeaderField: "link") {
            paginationInfo = try PaginationInfo(githubLinkHeader: linkHeader)
        } else {
            paginationInfo = .init()
        }
        
        logger.debug("fetchPage for \(url) succeeded")
        return (items, paginationInfo)
    }
}
