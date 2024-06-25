//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import Foundation
import API

/// `actor` to prevent race conditions during `requestTimestamps` alterations.
public actor RateLimiter {
    
    public struct Config {
        /**
         The time interval in seconds, during which the limit is applicable.
         */
        public var interval: TimeInterval
        
        /**
         The maximum number of operations allowed during `interval`
         */
        public var limit: Int
        
        public init(interval: TimeInterval, limit: Int) {
            self.interval = interval
            self.limit = limit
        }
    }
    public var config: Config
    
    /// Request timestamps made in the past `rateLimit.interval` seconds.
    private var records: [Date]
    
    /**
     The one and only.
     
     - Parameter config: Contains rate limiting configuration (see `config` for details),
     and is set to `config` field without modifications. Can be changed later.
     
     - Parameter persistedRequestTimestamps: Can be passed
     to keep the track between app launches.
     */
    public init(
        _ config: Config,
        persistedRequestTimestamps: [Date] = .init()
    ) {
        self.config = config
        self.records = persistedRequestTimestamps
    }
    
}

public extension RateLimiter {
    
    /**
     - parameter forceAllow: If `true`, cleans up the outdated request timestamps and returns.
     Use it if the rate limiter is temporary disabled. Added for convenience reasons.
     
     - parameter refDate: The reference date against which the number of records is counted.
     
     - parameter cleanupOutdatedRecords: If `true`, cleans up the outdated records in-place. Can be
     done explicitly via `cleanupOutdatedRecords`.
     */
    func checkLimitExceeded(
        forceAllow: Bool = false,
        refDate: Date = .now,
        cleanupOutdatedRecords: Bool = true
    ) throws {
        let relevantRecords = records(relevantTo: refDate, cleanupInPlace: cleanupOutdatedRecords)
        guard forceAllow || relevantRecords.count < config.limit else {
            if let oldestTimestamp = relevantRecords.first {
                let timeRemainig = refDate.timeIntervalSince(oldestTimestamp)
                throw ApiError.rateLimitExceeded(config, timeRemainig)
            } else {
                // config.limit <= 0
                throw ApiError.rateLimitTooLow(config.limit)
            }
        }
    }
    
    /**
     Records the operation timestamp.
     
     - parameter timestamp: The timestamp to be recorded.
     
     - parameter ignoreOrderViolation: For sensitive applications, it might be important to ensure
     the correct order of the records (e.g., to use binary search in `cleanupOutdatedRequestTimestamps`).
     Normally, however, minor violations of the order should not
     present any threat, and it would be wiser to avoid unneeded `throw`s in such cases.
     */
    func record(
        _ timestamp: Date = .now,
        ignoreOrderViolation: Bool = true
    ) throws {
        let lastRecord = records.last ?? .distantPast
        guard ignoreOrderViolation || lastRecord <= timestamp else {
            throw ApiError.rateLimiterRecordsOrderViolation(lastRecord, timestamp)
        }
        records.append(timestamp)
    }
    
    // TODO: Doc
    @discardableResult
    func records(
        relevantTo refDate: Date = .now,
        cleanupInPlace: Bool = true
    ) -> ArraySlice<Date> {
        var outdatedItemsCount = 0
        let edgeDate = refDate.addingTimeInterval(-config.interval)
        for date in records {
            if date < edgeDate { outdatedItemsCount += 1 }
            else { break }
            /// Could've used binary search insted (as `requestTimestamps` is a sorted array) and
            /// get O(ln n) instead of O(n), but obviously it wouldn't make much difference in our scenario.
        }

        let result = records[outdatedItemsCount...]
        if cleanupInPlace {
            records = Array(result)
        }
        return result
    }
    
    /**
     While the same effect can be achieved via `records(relevantTo:, cleanupInPlace:)` call,
     this method adds clarity to the interface.
     */
    func cleanupOutdatedRecords(refDate: Date = .now) {
        _ = records(relevantTo: refDate, cleanupInPlace: true)
    }
}

private extension RateLimiter {


}
