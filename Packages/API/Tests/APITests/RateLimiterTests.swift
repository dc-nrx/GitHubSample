//
//  RateLimiterTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import XCTest
import Implementation

final class RateLimiterTests: XCTestCase {

//    var sut: RateLimiter!
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReachingLimit_noExceed_noThrow() async throws {
        var sut = RateLimiter(.init(interval: 10, limit: 30))
        for _ in 0..<30 {
            try await sut.record()
        }
    }

    func testLimitExceed_throwsCorrectError_withCorrectData() async throws {
        let config = RateLimiter.Config(interval: 10, limit: 30)
        var sut = RateLimiter(config)
        for _ in 0..<30 {
            try await sut.record(ignoreLimitExceededCheck: true)
        }
        do {
            try await sut.record()
            XCTFail("Error expected")
        } catch ApiError.rateLimitExceeded(let errConfig, let timeRemaining) {
            XCTAssertEqual(config, errConfig)
            XCTAssertEqual(timeRemaining, config.interval, accuracy: 0.1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}
