//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import Foundation
import API

public actor RateLimiter {
    
    public struct Config {
        public var interval: TimeInterval
        public var limit: Int
        
        public init(interval: TimeInterval, limit: Int) {
            self.interval = interval
            self.limit = limit
        }
    }
    public let config: Config
    
    /// Request timestamps made in the past `rateLimit.interval`
    private var requestTimestamps = [Date]()
    
    public init(_ config: Config) {
        self.config = config
    }
    
    public func checkLimitExceeded(forceAllow: Bool) throws {
        cleanupOutdatedRequestTimestamps()
        guard forceAllow || requestTimestamps.count < config.limit else {
            if let oldestTimestamp = requestTimestamps.first {
                let timeRemainig = Date.now.timeIntervalSince(oldestTimestamp)
                throw ApiError.rateLimitExceeded(config, timeRemainig)
            } else {
                throw ApiError.rateLimitTooLow(config.limit)
            }
        }
    }
    
    public func record(_ timestamp: Date = .now) {
        requestTimestamps.append(timestamp)
    }
}

private extension RateLimiter {

    func cleanupOutdatedRequestTimestamps() {
        var outdatedItemsCount = 0
        let refDate = Date.now.addingTimeInterval(-config.interval)
        for date in requestTimestamps {
            if date < refDate { outdatedItemsCount += 1 }
            else { break }
        }
        requestTimestamps.removeFirst(outdatedItemsCount)
    }

}
