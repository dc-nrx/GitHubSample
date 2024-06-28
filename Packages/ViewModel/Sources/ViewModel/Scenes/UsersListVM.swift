//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import Foundation
import API

public class UsersListVM<UsersPaginator: Paginator, ReposPaginator: Paginator>: 
    PaginatorVM<UsersPaginator> where UsersPaginator.Item == User, ReposPaginator.Item == ReposPaginator {
    
    public var reposPaginator: ReposPaginator?
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
