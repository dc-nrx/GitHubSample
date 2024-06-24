//
//  GitHubAPIImplementationTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import XCTest
import Foundation
@testable import Implementation

final class GitHubAPIImplementationTests: XCTestCase {
    
    var sut: GitHubAPIImplementation!
    
    override func setUpWithError() throws {
        sut = GitHubAPIImplementation(baseURL: URL(string: "https://sample")!)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() async throws {
        try await sut.fetchUsers(since: 0, perPage: 10)
    }

}
