// The Swift Programming Language
// https://docs.swift.org/swift-book

public protocol GitHubAPI {
    associatedtype PaginationInfo: PaginationInfoProtocol
    
    /// `perPage`  <= 100
    func fetchUsers(since: User.ID, perPage: Int) async throws -> ([User], PaginationInfo)
    
    func fetchUsers(pageToken: PaginationInfo.Token) async throws -> ([User], PaginationInfo)
}
