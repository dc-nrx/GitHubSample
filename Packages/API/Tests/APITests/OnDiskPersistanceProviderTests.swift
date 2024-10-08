//
//  OnDiskPersistanceProviderTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 25.06.2024.
//

import XCTest
import Implementation

final class OnDiskPersistanceProviderTests: XCTestCase {

    var sut: OnDiskPersistanceProvider!
    
    override func setUpWithError() throws {
        sut = try OnDiskPersistanceProvider()
    }

    override func tearDown() async throws {
        try await sut.deleteAll()
        sut = nil
    }

    func testStoreString_validKeys_readWriteSuccessful() async throws {
        try await _testReadWriteSuccessful("Test1", for: "aKey1")
        try await _testReadWriteSuccessful("Test2", for: "a_Key1")
        try await _testReadWriteSuccessful("Test3", for: "a-Key1")
    }

    func testStoreString_underUnsupportedKey_throwsCorrectError() async throws {
        try await _testWriteThrows(for: "a b")
        try await _testWriteThrows(for: "a^b")
        try await _testWriteThrows(for: "/ab")
    }

    func testReadMissingIntValue_returnsNil() async throws {
        let val: Int? = try await sut.readValue(for: "key")
        XCTAssertNil(val)
    }
    
    func testStoreDate_validKeys_overwriteSameKey_readCorrectValue() async throws {
        try await _testReadWriteSuccessful("Test", for: "aKey1")
        try await _testReadWriteSuccessful("Test", for: "aKey2")
    }
    
    func testDeleteAll() async throws {
        let key = "kkk"
        try await sut.write(1, for: key)
        try await sut.deleteAll()
        
        let retrievedValue: Int? = try await sut.readValue(for: key)
        XCTAssertNil(retrievedValue)
    }
}

private extension OnDiskPersistanceProviderTests {
    
    func _testReadWriteSuccessful(_ value: String, for key: String) async throws {
        try await sut.write(value, for: key)
        let retrievedValue: String? = try await sut.readValue(for: key)
        XCTAssertEqual(value, retrievedValue)
    }
    
    func _testWriteThrows(_ value: String = "Test", for key: String) async throws {
        do {
            try await sut.write(value, for: key)
            XCTFail("Error expected while writing `\(value)` for `\(key)`")
        } catch ApiError.unsupportedKey(let errKey) {
            XCTAssertEqual(key, errKey)
        } catch {
            XCTFail("Unexpected error while writing `\(value)` for `\(key)`: \(error)")
        }
    }
}
