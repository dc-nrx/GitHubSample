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

public class UsersListVM<UsersP: UsersPaginator, ReposP: UserReposPaginator>: PaginatorVM<UsersP> {
    
    public typealias UserDetailsVMFactory = (User) -> UserDetailsVM<ReposP>
    
    // TODO: make proper init
    public var userDetailsFactory: UserDetailsVMFactory!

//    public var makeUserDetailsVM
//
//    public init(
//        paginator: P,
//        filter: P.Filter,
//        pageSize: Int,
//        pathMonitor: NWPathMonitor = .init(),
//        distanceBeforePrefetch: Int = 10
//    ) {
//        
//    }
    
}
