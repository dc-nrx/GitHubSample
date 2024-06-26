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
    public var delay: TimeInterval
    public private(set) var perPage = 30
    
    public init(
        delay: TimeInterval = 0
    ) {
        self.delay = delay
    }
}

extension GitHubAPIMock: UsersPaginator {
    public typealias PaginationInfo = IntPaginationInfo
    
    public func fetch(since: User.ID, perPage: Int) async throws -> ([User], IntPaginationInfo) {
        let users = usersPool.dropFirst(since).prefix(perPage)
        self.perPage = perPage
        let next = (users.last?.id != usersPool.last?.id) ? 1 : nil
        
        try await Task.sleep(seconds: delay)
        return (Array(users), IntPaginationInfo(next: next))
    }
    
    public func fetch(pageToken: Int) async throws -> ([User], IntPaginationInfo) {
        let users = usersPool.dropFirst(pageToken * perPage).prefix(perPage)
        let next = (users.last?.id != usersPool.last?.id) ? pageToken + 1 : nil
        
        try await Task.sleep(seconds: delay)
        return (Array(users), IntPaginationInfo(next: next))
    }
}
