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
public protocol Paginator<Item, PaginationInfo> {
    associatedtype Item: Identifiable
    associatedtype PaginationInfo: PaginationInfoProtocol
    associatedtype Filter
    
    func fetch(_ filter: Filter, perPage: Int) async throws -> ([Item], PaginationInfo)
    func fetch(pageToken: PaginationInfo.Token) async throws -> ([Item], PaginationInfo)
}
