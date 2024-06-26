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
    
    @Environment(\.scenePhase) 
    var scenePhase
    
    @StateObject
    var dependencyContainer = DependencyContainer()
        
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if let rootVM = dependencyContainer.rootVM {
                    UsersView(vm: rootVM)
                } else {
                    Text("Initialization...")
                }
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            dependencyContainer.scenePhaseChanged(to: newValue)
        }
    }
}
