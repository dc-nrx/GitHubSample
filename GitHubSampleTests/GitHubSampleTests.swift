//
//  GitHubSampleTests.swift
//  GitHubSampleTests
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import XCTest
import Combine

@testable import GitHubSample

final class GitHubSampleTests: XCTestCase {

    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = .init()
    }

    override func tearDownWithError() throws {
        cancellables = nil
    }

    func testTokenEnvVariable_isAvalable() {
        XCTAssertNotNil(Env.shared.githubAuthToken)
    }
    
    func testSessionToken_equalsToEnvToken() async throws {
        let sut = DependencyContainer()
        let exp = XCTestExpectation(description: "init finished")
        sut.$rootVM
            .filter { $0 != nil }
            .sink { _ in exp.fulfill() }
            .store(in: &cancellables)
        await fulfillment(of: [exp], timeout: 0.1)
        XCTAssertEqual(sut.sessionManager.authToken, Env.shared.githubAuthToken)
    }
}
