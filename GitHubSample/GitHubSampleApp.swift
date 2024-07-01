//
//  GitHubSampleApp.swift
//  GitHubSample
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import SwiftUI
import TipKit

import UI
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
            .task {
                if #available(iOS 17, *) {
                    setupTips()
                }
            }
        }
    }
    
    @available(iOS 17, *)
    func setupTips() {
        do {
            try Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
        catch {
            // Handle TipKit errors
            print("Error initializing TipKit \(error.localizedDescription)")
        }
    }
}
