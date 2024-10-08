//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API

/**
 The standard implementation of `PaginationInfoProtocol`.
 
 Used to extract the pagination urls from the API response headers, and use them afterwards.
 */
public struct UrlPaginationInfo: PaginationInfoProtocol, Equatable {
    public typealias Token = URL
    
    public var next: URL?
    public var prev: URL?
    public var first: URL?
    public var last: URL?
    
    public init(next: URL? = nil, prev: URL? = nil, first: URL? = nil, last: URL? = nil) {
        self.next = next
        self.prev = prev
        self.first = first
        self.last = last
    }
}

public extension UrlPaginationInfo {

    init(githubLinkHeader: String) throws {
        self.init()
        let records = githubLinkHeader.components(separatedBy: ",")
        
        for record in records {
            if try safeSet(keyPath: \.first, linkKey: "first", from: record) { continue }
            if try safeSet(keyPath: \.last, linkKey: "last", from: record) { continue }
            if try safeSet(keyPath: \.next, linkKey: "next", from: record) { continue }
            if try safeSet(keyPath: \.prev, linkKey: "prev", from: record) { continue }
        }
    }
}

private extension UrlPaginationInfo {
    
    mutating func safeSet(
        keyPath: WritableKeyPath<UrlPaginationInfo, URL?>,
        linkKey: String,
        from record: String
    ) throws -> Bool {
        if record.contains(linkKey) {
            guard self[keyPath: keyPath] == nil else {
                throw ApiError.duplicatePaginationLink(linkKey)
            }
            self[keyPath: keyPath] = link(from: record)
            return true
        } else {
            return false
        }
    }
    
    func link(from headerRecord: String) -> URL? {
        guard let linkString = headerRecord.slice(from: "<", to: ">;") else {
            return nil
        }
        return URL(string: linkString)
    }
}

private extension String {
    
    func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }
    
}
