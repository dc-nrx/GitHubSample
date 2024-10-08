//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import Foundation
import API
import OSLog

/**
 Rate limiter to track record of all requests and limit them as required.
 
 - Note: `actor` is used to prevent race conditions during `records` alterations.
 */
public actor RateLimiter {
    public typealias Record = Date
    
    public struct Config: Equatable {
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
    
    /**
     Saves the records to the persistant store, to be preserved between app launches.
     */
    private var save: ([Record]) -> ()
    
    /**
     The records that have been tracked and have not been cleaned up. made in the past `rateLimit.interval` seconds.
     See `cleanupOutdatedRecords(refRecord:)` for details.
     
     `Record` typealias is used in case we will want to alter/extend it in the future.
     */
    private var records: [Record]
    
    private let logger = Logger(subsystem: "Implementation", category: "RateLimiter")
    
    /**
     The one and only.
     
     - Parameter config: Contains rate limiting configuration (see `config` for details),
     and is set to `config` field without modifications. Can be changed later.
     
     - Parameter persistedRecords: Can be passed to keep the track between app launches.
     
     - Parameter save: The function that saves the records to persistant store. Being called upon each successful `record` call.
     */
    public init(
        _ config: Config,
        persistedRecords: [Record] = .init(),
        save: @escaping ([Record]) -> ()
    ) {
        self.config = config
        self.records = persistedRecords
        self.save = save
        
        logger.info("Initialized with interval: \(config.interval), limit: \(config.limit), persistedRecords: \(persistedRecords)")
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
        refDate: Date = .now,
        cleanupOutdatedRecords: Bool = true
    ) throws {
        let relevantRecords = records(relevantTo: refDate, cleanupInPlace: cleanupOutdatedRecords)
        guard relevantRecords.count < config.limit else {
            if let oldestTimestamp = relevantRecords.first {
                let timeRemainig = config.interval - refDate.timeIntervalSince(oldestTimestamp)
                throw ApiError.rateLimitExceeded(config, timeRemainig)
            } else {
                // config.limit <= 0
                throw ApiError.rateLimitTooLow(config.limit)
            }
        }
    }
    
    /**
     Records the operation timestamp if the limit has not been exceeded, or if `ignoreLimitExceededCheck` is `true`.
     Throws `ApiError.rateLimitExceeded` otherwise.
     
     - Parameter rec: The timestamp to be recorded.
     
     - Parameter ignoreLimitExceededCheck: If `true`, add the record without throwing an error
     without checking if the limit has been exceeded.
     
     - Parameter cleanupInPlace: If true, cleans up all the records that are older than `rec - config.interval`

     - Parameter ignoreOrderViolation: For sensitive applications, it might be important to ensure
     the correct order of the records (e.g., to use binary search in `cleanupOutdatedRequestTimestamps`).
     Normally, however, minor violations of the order should not
     present any threat, and it would be wiser to avoid unneeded `throw`s in such cases.
     */
    func record(
        _ rec: Record = .now,
        ignoreLimitExceededCheck: Bool = false,
        cleanupOutdatedRecords: Bool = true,
        ignoreOrderViolation: Bool = true
    ) throws {
        logger.info("Record requested for \(rec), ignoreLimit: \(ignoreLimitExceededCheck), cleanup: \(cleanupOutdatedRecords), ignoreOrder: \(ignoreOrderViolation)")
        if !ignoreLimitExceededCheck {
            try checkLimitExceeded(refDate: rec, cleanupOutdatedRecords: cleanupOutdatedRecords)
        }
        
        let lastRecord = records.last ?? .distantPast
        guard ignoreOrderViolation || lastRecord <= rec else {
            throw ApiError.rateLimiterRecordsOrderViolation(lastRecord, rec)
        }
        records.append(rec)
        save(records)
        
        logger.debug("Record \(rec) added. Total count: \(self.records.count)")
    }
    
    /**
     Get all records that have been made during `config.interval` before `refDate`.
     
     - Parameter relevantTo: The reference date to check the records age against.
     - Parameter cleanupInPlace: If true, cleans up all the records that are older than `refDate - config.interval`
     
     - Returns: An array slice containing all the records within the requested time interval.
     */
    @discardableResult
    func records(
        relevantTo refDate: Date = .now,
        cleanupInPlace: Bool = true
    ) -> ArraySlice<Record> {
        var outdatedItemsCount = 0
        let edgeDate = refDate.addingTimeInterval(-config.interval)
        for rec in records {
            if rec < edgeDate { outdatedItemsCount += 1 }
            else { break }
            /// Could've used binary search insted (as `requestTimestamps` is a sorted array) and
            /// get O(ln n) instead of O(n), but obviously it wouldn't make much difference in our scenario.
        }

        let result = records[outdatedItemsCount...]
        if cleanupInPlace {
            records = Array(result)
            logger.debug("\(outdatedItemsCount) records cleand up against refDate: \(refDate)")
            logger.info("Edge date = \(edgeDate)")
        }
        return result
    }
    
    /**
     Clean up all records that have been recorded earlier than `config.interval` seconds before `refRecord`.
     
     While the same effect can be achieved via `records(relevantTo:, cleanupInPlace:)` call,
     this method adds clarity to the interface.
     */
    func cleanupOutdatedRecords(refRecord: Record = .now) {
        _ = records(relevantTo: refRecord, cleanupInPlace: true)
    }
}
