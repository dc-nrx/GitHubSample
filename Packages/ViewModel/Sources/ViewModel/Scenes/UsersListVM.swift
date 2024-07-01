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
    
    // TODO: make proper init
    public var userDetailsFactory: UserDetailsVMFactory!
}
