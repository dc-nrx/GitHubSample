// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import SwiftUI
import API

@MainActor
public class UsersListVM: ObservableObject {
    
    @Published
    public var users = [User]()
    
    @Published
    public var showRefreshControl = false

    @Published
    public var showLoadingNextPage = false
    
    @Published
    public var errorMessage: String?

    private let api: GitHubAPI
    
    init(api: GitHubAPI) {
        self.api = api
    }
}

public extension UsersListVM {
    
}
