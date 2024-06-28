//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import Foundation
import API

public class ApiMock: GitHubAPI {
    public typealias PaginationInfo = IntPaginationInfo
    public typealias Users = UsersPaginatorMock
    public typealias Repos = ReposPaginatorMock
    
    public let users: Users
    public let repos: Repos
    
    public init(
        users: Users = UsersPaginatorMock(),
        repos: Repos = ReposPaginatorMock()
    ) {
        self.repos = repos
        self.users = users
    }
}
