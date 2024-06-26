// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public typealias GitHubAPI = UsersPaginator

public protocol UsersPaginator: PaginationAPI where Item == User { }

/**
 Unfortunatelly, this approach does not allow multiple conformance (e.g, to both
 PaginationAPI<Item, ...> and PaginationAPI<Repo, ...>). There are workarounds though,
 and the most promising one seems to be writing a macro.
 As the matter of fact, recently I had a discussion around it on StackOverflow:
 https://stackoverflow.com/questions/78612023/multiple-conformance-to-same-protocol-with-different-associated-types
 */
public protocol PaginationAPI<Item, PaginationInfo> {
    associatedtype Item: Identifiable
    associatedtype PaginationInfo: PaginationInfoProtocol

    func fetch(since: Item.ID, perPage: Int) async throws -> ([Item], PaginationInfo)
    func fetch(pageToken: PaginationInfo.Token) async throws -> ([Item], PaginationInfo)
}

