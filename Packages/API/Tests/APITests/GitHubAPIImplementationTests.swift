//
//  GitHubAPIImplementationTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import XCTest
import Foundation

import API
import Implementation
import Preview

final class GitHubAPIImplementationTests: XCTestCase {
    
    var sut: UsersUrlPaginator!
    var sessionManager: GitHubSessionManager!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession.init(configuration: configuration)
        
        sessionManager = GitHubSessionManager(
            session: mockSession,
            rateLimiter: RateLimiter(.init(interval: 60, limit: 60)) { _ in }
        )
        sut = .init(baseURL: URL(string: "https://sample")!, sessionManager: sessionManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        sessionManager = nil
        updateRequestHandler(to: nil)
        updateRequestSpy(to: nil)
    }

    // TODO: Add requestSpy tests to check `since` and `per_page` params are passed correctly.
    func testAuthToken_isCorrect() async {
        let token = "test token"
        sessionManager.authToken = token
        updateRequestHandler(to: .statusCode(200, nil))
        updateRequestSpy { [token] request in
            guard let authValue = request.value(forHTTPHeaderField: GitHubSessionManager.authKey) else {
                XCTFail("\(GitHubSessionManager.authKey) header is missing from \(request.allHTTPHeaderFields)")
                return
            }
            XCTAssertEqual("Bearer \(token)", authValue)
        }
        do {
            try await sut.fetch(0, perPage: 10)
        } catch {
            // Of no importance here
        }
    }
    
    /// There's a better way to implement parameter-based tests using
    /// `Swift Testing` framework - but presently it's available only in beta :(
    func testResponseDataLinkHeader_caseInsensitiveSupport() async throws {
        let linkHeaderTest: (String) async -> () = { [self] linkHeaderKey in
            let customResponse = HTTPURLResponse(url: URL(string: "http://sample")!, statusCode: 200, httpVersion: nil, headerFields: [linkHeaderKey: "zzzz"])!
            updateRequestHandler(to: .stub(customResponse, "Test".data(using: .utf8)))
            do {
                try await sut.fetch(0, perPage: 10)
                XCTFail("Expected error")
            } catch ApiError.failedToRetrievePaginationInfoHeader(_) {
                XCTFail("Pagination info header stored under `\(linkHeaderKey)` header key should have been found in \(customResponse.allHeaderFields)")
            } catch {
                // expected to fail at certain point
            }
        }
        
        await linkHeaderTest("link")
        await linkHeaderTest("Link")
        await linkHeaderTest("LINK")
        await linkHeaderTest("lINK")
    }
    
    func testPaginationInfoHeaderMissing_returnsEmptyPaginationInfo() async throws {
        updateRequestHandler(to: .statusCode(200, Samples.usersResponseData))
        let (_, info) = try await sut.fetch(0, perPage: 10)
        let emptyInfo = UrlPaginationInfo(next: nil, prev: nil, first: nil, last: nil)
        XCTAssertEqual(info, emptyInfo)
    }
    
    func testRateLimit_throwsCorrectError_onExceed() {
        
    }
}

private extension GitHubAPIImplementationTests {
    
    func updateRequestHandler(to handler: RequestHandler?) {
        MockURLProtocol.requestHandler = handler
    }
    
    func updateRequestSpy(to spy: RequestSpy?) {
        MockURLProtocol.requestSpy = spy
    }
}
