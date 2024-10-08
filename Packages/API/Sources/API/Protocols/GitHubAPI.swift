// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/**
 The protocol represents the remote API provided by github.
 */
public protocol GitHubAPI<PaginationInfo>: AnyObject {
    associatedtype PaginationInfo: PaginationInfoProtocol
    
    associatedtype Users: UsersPaginator where Users.PaginationInfo == PaginationInfo
    var users: Users { get }
    
    associatedtype Repos: UserReposPaginator where Repos.PaginationInfo == PaginationInfo
    var repos: Repos { get }
    
    func userDetails(_ username: String) async throws -> User
}
