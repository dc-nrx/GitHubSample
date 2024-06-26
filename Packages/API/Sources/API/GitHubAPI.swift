// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public typealias GitHubAPI = PaginationAPI

public protocol PaginationAPI {

    /// `perPage`  <= 100
    func fetch(since: User.ID, perPage: Int) async throws -> ([User], PaginationInfo)
    
    func fetch(pageToken: PaginationInfo.Token) async throws -> ([User], PaginationInfo)
}
