//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation

public struct User: Identifiable, Codable, Hashable {
    
    public var isExtended: Bool { createdAt != nil }
    
    // MARK: - Basic Properties

    public var login: String
    public var id: Int
    public var nodeId: String
    public var avatarUrl: URL
    public var gravatarId: String
    public var url: URL
    public var htmlUrl: URL
    public var followersUrl: URL
    public var followingUrl: String
    public var gistsUrl: String
    public var starredUrl: String
    public var subscriptionsUrl: URL
    public var organizationsUrl: URL
    public var reposUrl: URL
    public var eventsUrl: String
    public var receivedEventsUrl: URL
    public var type: String
    public var siteAdmin: Bool
    
    // MARK: - Extended Properties

    public var name: String?
    public var company: String?
    public var location: String?
    public var email: String?
    public var hireable: Bool?
    public var bio: String?
    public var twitterUsername: String?
    public var publicRepos: Int?
    public var publicGists: Int?
    public var followers: Int?
    public var following: Int?
    public var createdAt: Date?
    public var updatedAt: Date?
}
