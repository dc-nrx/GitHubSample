//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import Foundation

public struct RateLimit {
    public var interval: TimeInterval
    public var limit: Int
    
    public init(interval: TimeInterval, limit: Int) {
        self.interval = interval
        self.limit = limit
    }
}
