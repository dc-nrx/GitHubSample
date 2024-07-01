//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API
import Implementation

public final class Samples {
    
    public static let paginationInfo = UrlPaginationInfo(
        next: URL(string: "https://api.github.com/users?page=2")!,
        prev: URL(string: "https://api.github.com/users?page=4")!,
        first: URL(string: "https://api.github.com/users?page=1")!,
        last: URL(string: "https://api.github.com/users?page=515")!
    )
    
    public static func linkHeader(
        next: Bool = true,
        prev: Bool = true,
        first: Bool = true,
        last: Bool = true,
        reverseOrder: Bool = false
    ) -> String {
        var links = [String]()
        if next {
            links.append("<\(paginationInfo.next!.absoluteString)>; rel=\"next\"")
        }
        if prev {
            links.append("<\(paginationInfo.prev!.absoluteString)>; rel=\"prev\"")
        }
        if last {
            links.append("<\(paginationInfo.last!.absoluteString)>; rel=\"last\"")
        }
        if first {
            links.append("<\(paginationInfo.first!.absoluteString)>; rel=\"first\"")
        }
        if reverseOrder {
            links.reverse()
        }
        
        return links.joined(separator: ",")
    }
    
    /// Global is already `lazy`, thus no performance concern for production code
    public static var users = [User](jsonFile: "users70_page1") + [User](jsonFile: "users70_page2")
    public static var repos = [Repo](jsonFile: "repos_50_page1")
    public static var userDetails = User(jsonFile: "user")
    
    public static var usersResponseData: Data {
        let url = Bundle.module.url(forResource: "users70_page1", withExtension: "json")
        return try! Data(contentsOf: url!)
    }
}
