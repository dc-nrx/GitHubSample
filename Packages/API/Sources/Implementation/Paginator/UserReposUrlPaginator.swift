//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation
import API

/**
 Tests:
 - on-page has no link header - no throw
 */
public class UserReposUrlPaginator: UrlPaginator<Repo>, Paginator {
        
    public func fetch(_ filter: UserReposFilter, perPage: Int) async throws -> ([Repo], PaginationInfo) {
        guard !filter.username.isEmpty else {
            throw ApiError.cantBeEmpty("username")
        }
        var query = filter.query
        query["per_page"] = perPage
        
        if filter.excludeForks {
            postFetchFilter = { !$0.fork }
        }
        
        let url = try URL(base: baseURL, path: "users/\(filter.username)/repos", query: query)
        return try await fetchPage(url: url)
    }
}

private extension UserReposFilter {
    var query: [String: Any] {
        var result = [String: Any]()
        if let page {
            result["page"] = page
        }
        if let type {
            result["type"] = type.rawValue
        }
        if let sortOrder {
            result["direction"] = sortOrder.rawValue
        }
        if let sortKey {
            result["sort"] = sortKey.rawValue
        }
        return result
    }
}
