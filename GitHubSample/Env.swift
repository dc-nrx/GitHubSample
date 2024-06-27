//
//  Env.swift
//  GitHubSample
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation

public final class Env {
    public static let shared = Env()

    private lazy var envDict = Bundle.main.infoDictionary
    
    public lazy var githubAuthToken: String? = {
        envDict?["GITHUB_AUTH_TOKEN"] as? String
    }()
}
