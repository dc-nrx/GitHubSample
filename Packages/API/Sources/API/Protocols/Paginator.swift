//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation

/**
 Unfortunatelly, this approach does not allow multiple conformance - e.g, conforming a particular type
 to both PaginationAPI<Item, ...> and PaginationAPI<Repo, ...>.
 There are workarounds though, and the most promising one seems to be using a macro.
 */
public protocol Paginator<Item, Filter> {
    associatedtype Item: Identifiable
    associatedtype Filter
    associatedtype PaginationInfo: PaginationInfoProtocol
    
    func fetch(_ filter: Filter, perPage: Int) async throws -> ([Item], PaginationInfo)
    func fetch(pageToken: PaginationInfo.Token) async throws -> ([Item], PaginationInfo)
}

public typealias UserReposPaginator = Paginator<Repo, UserReposFilter>
public typealias UsersPaginator = Paginator<User, Int>

/**
 A protocol is used instead to keep the architecture agnostic of the implementation detils.
 
 It is possible that in a future versions of the API URLs (which are used for pagination now)
 might get replaced with some other kind data (e.g. just a set of parameters)
 
 In addition to the ideological reasons, it has proven advantageous for a cleaner mocks implementation - see `PaginatorMock`.
 */
public protocol PaginationInfoProtocol {
    associatedtype Token
    
    var next: Token? { get }
    var prev: Token? { get }
    var first: Token? { get }
    var last: Token? { get }
}
