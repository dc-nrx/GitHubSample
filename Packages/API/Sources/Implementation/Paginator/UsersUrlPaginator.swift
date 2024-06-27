//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation
import API

public class UsersUrlPaginator: UrlPaginator<User>, Paginator {
    
    public func fetch(_ filter: User.ID, perPage: Int) async throws -> ([User], PaginationInfo) {
        let url = try URL(base: baseURL, path: "users", query: [
            "since": filter,
            "per_page": perPage
        ])
        return try await fetchPage(url: url)
    }
}
