//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import Foundation
import API


public class UserDetailsVM<P: UserReposPaginator>: ObservableObject {
    
    public let user: User
    public let reposPaginator: P
    
    public init(_ user: User, reposPaginator: P) {
        self.user = user
        self.reposPaginator = reposPaginator
    }
}

public class UsersListVM<API: GitHubAPI>: PaginatorVM<API.Users> {
    
    public typealias UserDetailsVMFactory = (User) -> UserDetailsVM<API.Repos>
    
    // TODO: make proper init
    public var userDetailsFactory: UserDetailsVMFactory!
    
}
