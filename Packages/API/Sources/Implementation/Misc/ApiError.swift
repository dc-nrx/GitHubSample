//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API

public enum ApiError: Error {
    case failedToRetrievePaginationInfoHeader(HTTPURLResponse)
    case cantBeEmpty(String)
    case invalidServerResponse(URLResponse)
    case httpError(Int)
    case duplicatePaginationLink(String)
    
    case rateLimitExceeded(RateLimiter.Config, _ timeRemaining: TimeInterval)
    case rateLimitTooLow(Int)
    case rateLimiterRecordsOrderViolation(_ latestRecord: Date, _ newRecord: Date)
    
    case unsupportedKey(String)
}

extension ApiError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .failedToRetrievePaginationInfoHeader(let response):
            return "Failed to retrieve pagination info header from response: \(response)"
        case .cantBeEmpty(let field):
            return "\(field) cannot be empty."
        case .invalidServerResponse(let response):
            return "Invalid server response: \(response)"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .duplicatePaginationLink(let link):
            return "Duplicate pagination link found: \(link)"
        case .rateLimitExceeded(let config, let timeRemaining):
            return "Rate limit exceeded. \(config); time remaining: \(String(format: "%.2f", timeRemaining)) seconds"
        case .rateLimitTooLow(let limit):
            return "Rate limit too low: \(limit)"
        case .rateLimiterRecordsOrderViolation(let latestRecord, let newRecord):
            return "Rate limiter records order violation. Latest record: \(latestRecord), new record: \(newRecord)"
        case .unsupportedKey(let key):
            return "Unsupported key: \(key)"
        }
    }
}
