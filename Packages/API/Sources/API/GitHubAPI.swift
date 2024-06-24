// The Swift Programming Language
// https://docs.swift.org/swift-book

public typealias GitHubAPI = GithubUsersAPI

public protocol PaginationSupport {
    associatedtype PaginationInfo: PaginationInfoProtocol
}

public protocol GithubUsersAPI: PaginationSupport {

    /// `perPage`  <= 100
    func fetchUsers(since: User.ID, perPage: Int) async throws -> ([User], PaginationInfo)
    
    func fetchUsers(pageToken: PaginationInfo.Token) async throws -> ([User], PaginationInfo)
}
