//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import Foundation
import API

public struct IntPaginationInfo: PaginationInfoProtocol {
    public var first, last, next, prev: Int?
}

public typealias UsersPaginatorMock = PaginatorMock<User, Int>
public typealias ReposPaginatorMock = PaginatorMock<Repo, UserReposFilter>

public class PaginatorMock<Item: Identifiable, Filter>: Paginator {
    public typealias PaginationInfo = IntPaginationInfo

    public var itemsPool: any RandomAccessCollection<Item>
    public var firstDelay: TimeInterval
    public var nextDelay: TimeInterval
    
    public private(set) var perPage = 30
    
    public init(
        itemsPool: any RandomAccessCollection<Item>,
        firstDelay: TimeInterval = 0,
        nextDelay: TimeInterval = 0
    ) {
        self.itemsPool = itemsPool
        self.firstDelay = firstDelay
        self.nextDelay = nextDelay
    }
    
    public func fetch(_ ignoredFilter: Filter, perPage: Int) async throws -> ([Item], PaginationInfo) {
        self.perPage = perPage
        return try await _fetch(0, delay: firstDelay)
    }

    public func fetch(pageToken: Int) async throws -> ([Item], IntPaginationInfo) {
        try await _fetch(pageToken, delay: nextDelay)
    }
}

private extension PaginatorMock {
    
    func _fetch(_ pageToken: Int, delay: TimeInterval) async throws -> ([Item], IntPaginationInfo) {
        let items = itemsPool.dropFirst(pageToken * perPage).prefix(perPage)
        let next = (items.last?.id != itemsPool.last?.id) ? pageToken + 1 : nil
        
        try await Task.sleep(seconds: delay)
        return (Array(items), IntPaginationInfo(next: next))
    }
}

public extension PaginatorMock where Item == User {
    convenience init(
        _ pool: any RandomAccessCollection<Item> = Samples.users,
        firstDelay: TimeInterval = 0,
        nextDelay: TimeInterval = 0
    ) {
        self.init(itemsPool: pool, firstDelay: firstDelay, nextDelay: nextDelay)
    }
}

public extension PaginatorMock where Item == Repo {
    convenience init(
        _ pool: any RandomAccessCollection<Item> = Samples.repos,
        firstDelay: TimeInterval = 0,
        nextDelay: TimeInterval = 0
    ) {
        self.init(itemsPool: pool, firstDelay: firstDelay, nextDelay: nextDelay)
    }
}
