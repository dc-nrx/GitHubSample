// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol GitHubAPI<PaginationInfo>: AnyObject {
    associatedtype PaginationInfo: PaginationInfoProtocol
    
    associatedtype Users: UsersPaginator where Users.PaginationInfo == PaginationInfo
    var users: Users { get }
    
    associatedtype Repos: UserReposPaginator where Repos.PaginationInfo == PaginationInfo
    var repos: Repos { get }
}
