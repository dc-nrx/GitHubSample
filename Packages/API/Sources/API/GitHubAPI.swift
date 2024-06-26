// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public typealias GitHubAPI = GithubUsersAPI

public protocol GithubUsersAPI {

    /// `perPage`  <= 100
    func fetchUsers(since: User.ID, perPage: Int) async throws -> ([User], UrlPaginationInfo)
    
    func fetchUsers(pageToken: UrlPaginationInfo.Token) async throws -> ([User], UrlPaginationInfo)
}
