//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import Foundation

/**
 A protocol is used primarily to support unit testing.
 
 The only use of it so far is to store the rate limiter data - so it gets preserved between app launches. (but not after app deletion)
 */
public protocol PersistanceProvider {
    
    func write<T: Codable>(_ value: T, for key: String) async throws
    func readValue<T: Codable>(for key: String) async throws -> T?
    func deleteAll() async throws
}
