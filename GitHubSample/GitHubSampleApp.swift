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
import API
import Implementation

@main
struct GitHubSampleApp: App {
    
    @StateObject
    var dependencyContainer = DependencyContainer()
        
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if let rootVM = dependencyContainer.rootVM {
                    UsersList(rootVM)
                        .navigationTitle("Users")
                } else {
                    Text("Initialization...")
                }
            }
        }
    }
}
