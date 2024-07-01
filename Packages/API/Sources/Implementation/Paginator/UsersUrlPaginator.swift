//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation
import API

/**
 The paginator to fetch users, starting from `sinceUserId`.
 
 As `sinceUserId` is the only supported parameter here, I didn't create a dedicated `struct`
 for filter here, and just used `Int` as a `Filter` associated type instead.
 */
public class UsersUrlPaginator: UrlPaginator<User>, Paginator {
    
    public func fetch(_ sinceUserId: User.ID, perPage: Int) async throws -> ([User], PaginationInfo) {
        let url = try URL(base: baseURL, path: "users", query: [
            "since": sinceUserId,
            "per_page": perPage
        ])
        return try await fetchPage(url: url)
    }
}
