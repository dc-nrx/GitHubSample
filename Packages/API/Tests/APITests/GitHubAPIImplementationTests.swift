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
    let token = "test token"
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession.init(configuration: configuration)
        
        sut = GitHubAPIImplementation(baseURL: URL(string: "https://sample")!, session: mockSession, authToken: token)
    }

    override func tearDownWithError() throws {
        sut = nil
        updateRequestHandler(to: nil)
        updateRequestSpy(to: nil)
    }

    func testAuthToken_isCorrect() async {
        updateRequestHandler(to: .statusCode(200, nil))
        updateRequestSpy { [token] request in
            guard let authValue = request.value(forHTTPHeaderField: GitHubAPIImplementation.authKey) else {
                XCTFail("\(GitHubAPIImplementation.authKey) header is missing from \(request.allHTTPHeaderFields)")
                return
            }
            XCTAssertEqual("Bearer \(token)", authValue)
        }
        do {
            try await sut.fetchUsers(since: 0, perPage: 10)
        } catch {
            // Of no importance here
        }
    }
    
    /// There's a better way to implement parameter-based tests
    /// using `Swift Testing` framework - but presently it's available only in beta :(
    func testResponseDataLinkHeader_caseInsensitiveSupport() async throws {
        let linkHeaderTest: (String) async -> () = { [self] linkHeaderKey in
            let customResponse = HTTPURLResponse(url: URL(string: "http://sample")!, statusCode: 200, httpVersion: nil, headerFields: [linkHeaderKey: "zzzz"])!
            updateRequestHandler(to: .stub(customResponse, "Test".data(using: .utf8)))
            do {
                try await sut.fetchUsers(since: 0, perPage: 10)
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
    
    func testPaginationInfoHeaderMissing_throwsCorrespondingError() async throws {
        updateRequestHandler(to: .statusCode(200, nil))
        do {
            try await sut.fetchUsers(since: 0, perPage: 10)
            XCTFail("Expected an error")
        } catch ApiError.failedToRetrievePaginationInfoHeader(_) {
            // expected behaviour
        } catch {
            XCTFail("Wrong error thrown \(error)")
        }
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
