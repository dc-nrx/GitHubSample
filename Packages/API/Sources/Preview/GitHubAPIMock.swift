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

public class GitHubAPIMock {
    
    public var usersPool = Samples.users
    public var firstDelay: TimeInterval
    public var nextDelay: TimeInterval
    public private(set) var perPage = 30
    
    public init(
        firstDelay: TimeInterval = 0,
        nextDelay: TimeInterval = 0
    ) {
        self.firstDelay = firstDelay
        self.nextDelay = nextDelay
    }
}

extension GitHubAPIMock: UsersPaginator {
    public typealias PaginationInfo = IntPaginationInfo
    
    public func fetch(since: User.ID, perPage: Int) async throws -> ([User], IntPaginationInfo) {
        let users = usersPool.dropFirst(since).prefix(perPage)
        self.perPage = perPage
        let next = (users.last?.id != usersPool.last?.id) ? 1 : nil
        
        try await Task.sleep(seconds: firstDelay)
        return (Array(users), IntPaginationInfo(next: next))
    }
    
    public func fetch(pageToken: Int) async throws -> ([User], IntPaginationInfo) {
        let users = usersPool.dropFirst(pageToken * perPage).prefix(perPage)
        let next = (users.last?.id != usersPool.last?.id) ? pageToken + 1 : nil
        
        try await Task.sleep(seconds: nextDelay)
        return (Array(users), IntPaginationInfo(next: next))
    }
}
