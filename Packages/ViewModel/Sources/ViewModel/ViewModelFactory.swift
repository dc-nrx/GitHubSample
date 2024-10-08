//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import Foundation
import API

@MainActor
public class ViewModelFactory<API: GitHubAPI> {
    
    private let api: API

    public init(api: API) {
        self.api = api
    }
    
    public func makeUsersVM() -> UsersListVM<API> {
        .init(api.users, filter: 0, pageSize: 30, userDetailsFactory: makeUserDetailsVM)
    }
    
    public func makeUserDetailsVM(_ user: User) -> UserDetailsVM<API> {
        .init(user, api: api)
    }
}
