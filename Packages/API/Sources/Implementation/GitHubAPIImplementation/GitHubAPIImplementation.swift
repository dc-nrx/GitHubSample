//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation
import API
import OSLog

public class GitHubAPIImplementation {
    public typealias PaginationInfo = UrlPaginationInfo
    
    static let authKey = "Authorization"
    
    public var authToken: String?    
    
    let baseURL: URL
    let logger = Logger(subsystem: "API", category: "GitHubAPIImplementation")
    
    private let session: URLSession
    
    private let rateLimit: RateLimit
    
    /// Request timestamps made in the past `rateLimit.interval`
    private var requestTimestamps = [Date]()
    
    public init(
        baseURL: URL = URL(string: "https://api.github.com")!,
        session: URLSession = .init(configuration: .default),
        rateLimit: RateLimit = .init(interval: 60*60, limit: 60),
        authToken: String? = nil
    ) {
        self.session = session
        self.baseURL = baseURL
        self.authToken = authToken
        self.rateLimit = rateLimit
    }
}

extension GitHubAPIImplementation {
       
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try checkRateLimit()
        requestTimestamps.append(.now)
        return try await session.data(for: request)
    }
    
    func makeRequest(_ method: HttpMethod, for url: URL) -> URLRequest {
        var result = URLRequest(url: url)
        result.allHTTPHeaderFields = commonHeaders
        result.httpMethod = method.rawValue
        return result
    }
    
    func makeDecoder() -> JSONDecoder {
        .init(keyStrategy: .convertFromSnakeCase)
    }
}

private extension GitHubAPIImplementation {
    
    var commonHeaders: [String: String] {
        var result = [
            "accept": "application/vnd.github+json"
        ]
        if let authToken {
            result[GitHubAPIImplementation.authKey] = "Bearer \(authToken)"
        }
        return result
    }

    var rateLimitIsActive: Bool {
        authToken == nil
    }
    
    func checkRateLimit() throws {
        cleanupRequestTimestamps()
        guard !rateLimitIsActive || requestTimestamps.count < rateLimit.limit else {
            if let oldestTimestamp = requestTimestamps.first {
                let timeRemainig = Date.now.timeIntervalSince(oldestTimestamp)
                throw ApiError.rateLimitExceeded(rateLimit, timeRemainig)
            } else {
                throw ApiError.rateLimitTooLow(rateLimit.limit)
            }
        }
    }

    func cleanupRequestTimestamps() {
        var outdatedItemsCount = 0
        let refDate = Date.now.addingTimeInterval(-rateLimit.interval)
        for date in requestTimestamps {
            if date < refDate { outdatedItemsCount += 1 }
            else { break }
        }
        requestTimestamps.removeFirst(outdatedItemsCount)
    }
}
