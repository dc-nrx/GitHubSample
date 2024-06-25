//
//  RateLimiterTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import XCTest
import Implementation

final class RateLimiterTests: XCTestCase {

    func testReachingLimit_noExceed_noThrow() async throws {
        _ = try await makeSut(interval: 10, limit: 30, filledUp: true)
    }

    func testLimitExceed_throwsCorrectError_withCorrectData() async throws {
        let (sut, config) = try await makeSut(interval: 10, limit: 20, filledUp: true)
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
    
    func testLimitReached_allGetsCleanedUp_afterIntervalPassed() async throws {
        let (sut, config) = try await makeSut(interval: 0.2, limit: 20, filledUp: true)
        for _ in 0..<config.limit {
            try await sut.record(.now + config.interval)
        }
    }
    
    func testLimitReached_exactlyHalfGetsCleanedUp_inDueTime() async throws {
        let (sut, config) = try await makeSut(interval: 0.2, limit: 20, filledUp: false)
        var refTime = Date.now
        for _ in 0..<config.limit/2 {
            try await sut.record(refTime)
        }
        
        refTime = .now + config.interval/2
        for _ in 0..<config.limit/2 {
            try await sut.record(refTime)
        }
        
        refTime = .now + config.interval
        for _ in 0..<config.limit/2 {
            try await sut.record(refTime)
        }
        
        do {
            try await sut.record(refTime)
            XCTFail("Error expected")
        } catch ApiError.rateLimitExceeded(let errConfig, let timeRemaining) {
            XCTAssertEqual(config, errConfig)
            XCTAssertEqual(timeRemaining, config.interval/2, accuracy: 0.05)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
    
    func testNonPositiveRateLimit_throwsCorrectErrorOnRecord() async throws {
        let sut = RateLimiter(.init(interval: 10, limit: 0))
        do {
            try await sut.record()
            XCTFail("Error expected")
        } catch ApiError.rateLimitTooLow(let lowLimit) {
            XCTAssertEqual(lowLimit, 0)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}

private extension RateLimiterTests {
    
    /**
     As `RateLimiter` is an actor, it is handy to have non-isolated `Config` as a separate var.
     */
    func makeSut(interval: TimeInterval, limit: Int, filledUp: Bool) async throws -> (RateLimiter, RateLimiter.Config) {
        let config = RateLimiter.Config(interval: interval, limit: limit)
        var sut = RateLimiter(config)
        if filledUp {
            for _ in 0..<limit {
                try await sut.record(ignoreLimitExceededCheck: true)
            }
        }
        return await (sut, sut.config)
    }
}
