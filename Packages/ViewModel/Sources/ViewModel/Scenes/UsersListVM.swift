//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import Foundation
import API

@MainActor
public class UsersListVM<API: GitHubAPI>: PaginatorVM<API.Users> {
    
    public typealias UserDetailsVMFactory = (User) -> UserDetailsVM<API>
    
    public var userDetailsFactory: UserDetailsVMFactory
    
    init(
        _ paginator: API.Users,
        filter: API.Users.Filter,
        pageSize: Int,
        prefetchDistance: Int? = 3,
        userDetailsFactory: @escaping UserDetailsVMFactory
    ) {
        self.userDetailsFactory = userDetailsFactory
        super.init(paginator, filter: filter, pageSize: pageSize, prefetchDistance: prefetchDistance)
    }
    
}
