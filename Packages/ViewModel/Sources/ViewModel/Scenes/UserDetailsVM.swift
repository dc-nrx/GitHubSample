//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 01.07.2024.
//

import Foundation
import API

@MainActor
public class UserDetailsVM<API: GitHubAPI>: ObservableObject {
    
    @Published
    public private(set) var user: User
    
    public let api: API
    
    public private(set) lazy var reposPaginatorVM = PaginatorVM(api.repos, filter: .init(username: user.login), pageSize: 30)
    
    public init(_ user: User, api: API) {
        self.user = user
        self.api = api
    }
    
    public func onAppear() async {
        reposPaginatorVM.onAppear()
        if !user.isExtended {
            await fetchUserDetails()
        }
    }
    
    @Sendable
    public func refresh() async {
        await reposPaginatorVM.asyncRefresh()
        await fetchUserDetails()
    }
}

private extension UserDetailsVM {
    
    func fetchUserDetails() async {
        user = try! await api.userDetails(user.login)
        print("### user updated to \(user)")
    }
}
