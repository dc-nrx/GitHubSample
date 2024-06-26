//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation

public typealias PaginationInfo = GenericPaginationInfo<URL>

public struct GenericPaginationInfo<T> {
    public typealias Token = T
    
    public var next: Token?
    public var prev: Token?
    public var first: Token?
    public var last: Token?
    
    public init(next: Token? = nil, prev: Token? = nil, first: Token? = nil, last: Token? = nil) {
        self.next = next
        self.prev = prev
        self.first = first
        self.last = last
    }
}

extension GenericPaginationInfo: Equatable where T: Equatable { }
