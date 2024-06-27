//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import Foundation

public struct Repo: Identifiable, Codable {
    public var id: Int
    public var nodeId: String
    public var name: String
    public var fullName: String
    public var isPrivate: Bool
    public var owner: User
    public var description: String?
    public var fork: Bool
    public var url: URL
    public var languagesUrl: URL
}
