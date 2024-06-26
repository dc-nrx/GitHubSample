//
//  DependencyContainer.swift
//  GitHubSample
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import Foundation
import OSLog

import API
import Implementation
import ViewModel
import SwiftUI

public final class DependencyContainer: ObservableObject {
    public typealias API = GitHubAPIImplementation
    
    private let rateLimiterKey = "rate_limiter"
    private let rateLimiterConfig = RateLimiter.Config(interval: 60*60, limit: 60)
    private let logger = Logger(subsystem: "GitHubSample", category: "DependencyContainer")
    
    @Published @MainActor
    public var rootVM: PaginatorVM<API>?
    
    private var persistanceProvider: PersistanceProvider?
    private var rateLimiter: RateLimiter!
    private var api: API!
    
    init() {
        logger.debug("Init")
        Task {
            persistanceProvider = try? OnDiskPersistanceProvider()
            if persistanceProvider == nil {
                logger.error("PersistanceProvider init failed. Rate limiter data will be reset.")
            }
            let persistedRecords: [RateLimiter.Record]? = try? await persistanceProvider?.readValue(for: rateLimiterKey)
            rateLimiter = RateLimiter(rateLimiterConfig, persistedRecords: persistedRecords ?? [])
            api = GitHubAPIImplementation(rateLimiter: rateLimiter)
            
            await MainActor.run {
                rootVM = .init(api: api, referenceID: 0, pageSize: 30)
            }
            logger.debug("Init finished")
        }
    }
    
    public func scenePhaseChanged(to newPhase: ScenePhase) {
        let newPhaseName = "\(newPhase)"
        logger.debug("Scene phase -> `\(newPhaseName)`")

        switch newPhase {
        case .background, .inactive:
            saveRateLimiterRecords()
        default:
            break
        }
    }
}

private extension DependencyContainer {
    
    func saveRateLimiterRecords() {
        logger.debug("Save rate limiter data requested")
        Task {
            do {
                let records = await Array(rateLimiter.records())
                try await self.persistanceProvider?.write(records, for: self.rateLimiterKey)
                if self.persistanceProvider == nil {
                    logger.error("persistanceProvider == nil. Rate limiter data has not been saved.")
                } else {
                    logger.debug("Rate limiter data has been saved")
                    logger.info("Records saved: \(records)")
                }
            } catch {
                logger.error("Error while saving rate limits: \(error)")
            }
        }
    }
}
