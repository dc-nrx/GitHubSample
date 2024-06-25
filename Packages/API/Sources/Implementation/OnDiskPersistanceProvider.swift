//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import Foundation
import API

public class OnDiskPersistanceProvider {
    
    public let allowedCharacters = CharacterSet(charactersIn: "-_").union(.alphanumerics)
    
    private let fileManager: FileManager
    private let directory: URL
    private let writingOptions: Data.WritingOptions
    
    init(
        directory: URL = .documentsDirectory.appending(path: "OnDiskPersistanceProvider"),
        fileManager: FileManager = .default,
        writingOptions: Data.WritingOptions = [.atomic, .completeFileProtection]
    ) throws {
        self.directory = directory
        self.writingOptions = writingOptions
        self.fileManager = fileManager
        
        try self.createDirectoryIfNeeded()
    }
}

/**
 Given expected size of data and frequency of use,
 moving respective operations to background is not neccessary at the moment.
 */
extension OnDiskPersistanceProvider: PersistanceProvider {
    
    public func store<T: Codable>(_ value: T, for key: String) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        let url = try url(for: key)
        try createDirectoryIfNeeded()
        try data.write(to: url, options: writingOptions)
    }
    
    public func readValue<T: Codable>(for key: String) async throws -> T? {
        let decoder = JSONDecoder()
        let url = try url(for: key)
        guard fileManager.isReadableFile(atPath: url.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: url)
        guard !data.isEmpty else { return nil }
        return try decoder.decode(T.self, from: data)
    }
    
    public func deleteAll() async throws {
        try fileManager.removeItem(at: directory)
    }
}

private extension OnDiskPersistanceProvider {
    
    func createDirectoryIfNeeded() throws {
        let exists = fileManager.fileExists(atPath: directory.path)
        guard !exists else { return }
        
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: false)
    }
    
    func url(for key: String) throws -> URL {
        guard key.rangeOfCharacter(from: allowedCharacters.inverted) == nil else {
            throw ApiError.unsupportedKey(key)
        }
        
        return directory.appending(path: "\(key).txt")
    }
}
