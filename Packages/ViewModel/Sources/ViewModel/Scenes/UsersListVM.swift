//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import Foundation
import API

@MainActor
public class UserDetailsVM<P: UserReposPaginator>: ObservableObject {
    
    public let user: User
    public let reposPaginatorVM: PaginatorVM<P>
    
    public init(_ user: User, reposPaginator: P) {
        self.user = user
        self.reposPaginatorVM = .init(reposPaginator, filter: .init(username: user.login), pageSize: 30)
    }
}

@MainActor
public class UsersListVM<API: GitHubAPI>: PaginatorVM<API.Users> {
    
    public typealias UserDetailsVMFactory = (User) -> UserDetailsVM<API.Repos>
    
    // TODO: make proper init
    public var userDetailsFactory: UserDetailsVMFactory!
    
}
