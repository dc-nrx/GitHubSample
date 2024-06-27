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
        let url = try URL(base: baseURL, path: "users", query: [:
            //...
        ])
        return try await fetchPage(url: url)
    }
}
