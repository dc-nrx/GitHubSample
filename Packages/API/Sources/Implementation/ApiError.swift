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
    case invalidServerResponse(URLResponse)
    case httpError(Int)
    case duplicatePaginationLink(String)
    case rateLimitExceeded(RateLimiter.Config, _ timeRemaining: TimeInterval)
    case rateLimitTooLow(Int)
}
