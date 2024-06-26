//
//  GitHubSampleApp.swift
//  GitHubSample
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import SwiftUI
import UI
import Preview
import ViewModel

@main
struct GitHubSampleApp: App {
    
    @MainActor
    let vm = PaginatorVM(
        api: GitHubAPIMock(delay: 0.4),
        referenceID: 0,
        pageSize: 30
    )
    
    var body: some Scene {
        WindowGroup {
            UsersView(vm: vm)
        }
    }
}
