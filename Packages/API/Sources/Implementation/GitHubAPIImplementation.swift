//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API

public class GitHubAPIImplementation: GitHubAPI {
    public typealias PaginationInfo = UrlPaginationInfo

    public func fetchUsers(since: User.ID, perPage: Int) async throws -> ([User], UrlPaginationInfo) {
        fatalError("not implemented")
    }
    
    public func fetchUsers(pageToken: URL) async throws -> ([User], UrlPaginationInfo) {
        fatalError("not implemented")
    }
}
