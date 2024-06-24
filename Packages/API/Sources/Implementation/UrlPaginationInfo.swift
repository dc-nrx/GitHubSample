//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API

public struct UrlPaginationInfo: PaginationInfoProtocol {
    public typealias Token = URL

    public var next: URL?
    public var prev: URL?
    public var first: URL?
    public var last: URL?

    init(githubLinkHeader: String) throws {
        fatalError("Not Implemented")
    }
    
    init(next: URL? = nil, prev: URL? = nil, first: URL? = nil, last: URL? = nil) {
        self.next = next
        self.prev = prev
        self.first = first
        self.last = last
    }
}
