//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation

//TODO: Add docs & default values from the off documentation
public struct UserReposFilter {
    
    /**
     The only required parameter.
     */
    public var username: String
    
    public var excludeForks = true
    
    public var page: Int?
    
    public enum OwnershipType: String {
        case all, owner, member
    }
    public var type: OwnershipType?
    
    public enum SortKey: String {
        case created, updated, pushed
        case fullName = "full_name"
    }
    public var sortKey: SortKey?

    public enum SortOrder: String {
        case asc, desc
    }
    public var sortOrder: SortOrder?
    
    public init(
        username: String,
        page: Int? = nil,
        type: OwnershipType? = nil,
        sortKey: SortKey? = nil,
        sortOrder: SortOrder? = nil
    ) {
        self.username = username
        self.page = page
        self.type = type
        self.sortKey = sortKey
        self.sortOrder = sortOrder
    }
}
