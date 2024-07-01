//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import Foundation

/**
 The struct representing a repository.
 */
public struct Repo: Identifiable, Codable {
    
    public var id: Int
    public var nodeId: String
    public var name: String
    public var fullName: String
    public var description: String?
    
    /// The repo `git` url.
    public var url: URL
    
    /// The url of title `html` page.
    public var htmlUrl: URL
    
    public var owner: User
    
    public var `private`: Bool
    public var fork: Bool
    
    public var stargazersCount: Int
    public var forksCount: Int
    public var language: String?
    public var languagesUrl: URL
    
}
