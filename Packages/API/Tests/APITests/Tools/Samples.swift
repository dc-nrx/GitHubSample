//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
@testable import Implementation

final class Samples {
    
    static let paginationInfo = UrlPaginationInfo(
        next: URL(string: "https://api.github.com/users?page=2")!,
        prev: URL(string: "https://api.github.com/users?page=4")!,
        first: URL(string: "https://api.github.com/users?page=1")!,
        last: URL(string: "https://api.github.com/users?page=515")!
    )
    
    static func linkHeader(
        next: Bool = true,
        prev: Bool = true,
        first: Bool = true,
        last: Bool = true,
        inverseOrder: Bool = false
    ) -> String {
        var links = [String]()
        if next {
            links.append("<\(paginationInfo.prev!.absoluteString)>; rel=\"prev\"")
        }
        if prev {
            links.append("<\(paginationInfo.next!.absoluteString)>; rel=\"next\"")
        }
        if last {
            links.append("<\(paginationInfo.last!.absoluteString)>; rel=\"last\"")
        }
        if first {
            links.append("<\(paginationInfo.first!.absoluteString)>; rel=\"first\"")
        }
        if inverseOrder {
            links.reverse()
        }
        
        return links.joined(separator: ",")
    }
}
