//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API

public struct UrlPaginationInfo: PaginationInfoProtocol, Equatable {
    public typealias Token = URL

    public var next: URL?
    public var prev: URL?
    public var first: URL?
    public var last: URL?

    init(githubLinkHeader: String) throws {
        let records = githubLinkHeader.components(separatedBy: ",")
        for record in records {
            if record.contains("prev") {
                prev = link(from: record)
            } else if record.contains("next") {
                next = link(from: record)
            } else if record.contains("first") {
                first = link(from: record)
            } else if record.contains("last") {
                last = link(from: record)
            }
        }
    }
    
    init(next: URL? = nil, prev: URL? = nil, first: URL? = nil, last: URL? = nil) {
        self.next = next
        self.prev = prev
        self.first = first
        self.last = last
    }
}

private extension UrlPaginationInfo {
        
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
