//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation
import API

public class ReposUrlPaginator: UrlPaginator<Repo>, Paginator {
    
    public struct Filter { }
    
    public func fetch(_ filter: Filter, perPage: Int) async throws -> ([Repo], PaginationInfo) {
        let url = try URL(base: baseURL, path: "users", query: [:
            //...
        ])
        return try await fetchPage(url: url)
    }
}
