//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import Foundation
import API


//public class UserDetailsVM<ReposPaginator: Paginator>: ObservableObject {
//    
//}

public class UsersListVM<UsersPaginator: Paginator, ReposPaginator: Paginator>:
    PaginatorVM<UsersPaginator> where UsersPaginator.Item == User, ReposPaginator.Item == ReposPaginator {
    
//    typealias UserDetailsVMFactory<P: Paginator> = (User) -> UserDetailsVM<P>
    
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
