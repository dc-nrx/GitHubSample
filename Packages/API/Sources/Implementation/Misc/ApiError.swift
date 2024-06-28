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
