// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum HttpMethod: String {
    case get, post
}

/**
 A single point of network access - responsible for auth, rate limits etc.
 */
public protocol SessionManager {
    
    func data(_ method: HttpMethod, from url: URL) async throws -> (Data, URLResponse)    
}

public protocol GitHubAPI<PaginationInfo>: AnyObject {
    associatedtype PaginationInfo: PaginationInfoProtocol
    
    associatedtype Users: PaginationAPI where Users.Item == User, Users.PaginationInfo == PaginationInfo
    var users: Users { get }
    
    associatedtype Repos: PaginationAPI where Repos.Item == Repo, Repos.PaginationInfo == PaginationInfo
    var repos: Repos { get }
}

/**
 Unfortunatelly, this approach does not allow multiple conformance - e.g, conforming a particular type
 to both PaginationAPI<Item, ...> and PaginationAPI<Repo, ...>.
 There are workarounds though, and the most promising one seems to be using a macro.
 */
public protocol PaginationAPI<Item, PaginationInfo> {
    associatedtype Item: Identifiable
    associatedtype PaginationInfo: PaginationInfoProtocol

    func fetch(since: Item.ID, perPage: Int) async throws -> ([Item], PaginationInfo)
    func fetch(pageToken: PaginationInfo.Token) async throws -> ([Item], PaginationInfo)
}
