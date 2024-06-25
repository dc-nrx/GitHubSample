//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import Foundation

public protocol PersistanceProvider {
    func store<T: Codable>(_ value: T, for key: String) async throws
    func readValue<T: Codable>(for key: String) async throws -> T
    func deleteAll() async throws
}
