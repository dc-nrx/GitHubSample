// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol GitHubAPI<PaginationInfo>: AnyObject {
    associatedtype PaginationInfo: PaginationInfoProtocol
    
    associatedtype Users: Paginator where Users.Item == User, Users.PaginationInfo == PaginationInfo
    var users: Users { get }
    
    associatedtype Repos: Paginator where Repos.Item == Repo, Repos.PaginationInfo == PaginationInfo
    var repos: Repos { get }
}
