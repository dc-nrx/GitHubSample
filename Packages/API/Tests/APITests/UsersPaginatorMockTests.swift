//
//  UsersPaginatorMockTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import XCTest
import Implementation
import Preview
import API

final class UsersPaginatorMockTests: XCTestCase {

    var sut: PaginatorMock<User, Int>!
    
    override func setUpWithError() throws {
        sut = .init()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testGithubApiMock_loadsFirst20Correctly() async throws {
        let (users, info) = try await sut.fetch(0, perPage: 20)
        XCTAssertEqual(users.count, 20)
    }
    
    func testGithubApiMock_loadsFirst30Correctly() async throws {
        let (users, info) = try await sut.fetch(0, perPage: 30)
        XCTAssertEqual(users.count, 30)
    }
    
    func testGithubApiMock_loadsFirstTwoPages30_allUnique() async throws {
        let (users1, info1) = try await sut.fetch(0, perPage: 30)
        let (users2, info2) = try await sut.fetch(pageToken: info1.next!)
        let allIDs = (users1 + users2).map(\.id)
        XCTAssertEqual(Set(allIDs).count, 60)
    }

    func testGithubApiMock_loadsOversizePage_noOverflow_nextIsNil() async throws {
        let (users, info) = try await sut.fetch(0, perPage: 400)
        XCTAssertEqual(users.count, sut.itemsPool.count)
        XCTAssertNil(info.next)
    }

    func testGithubApiMock_loads2GrandPages_noOverflow_nextIsNil() async throws {
        let pageSize = sut.itemsPool.count / 2 + 2
        let (users1, info1) = try await sut.fetch(0, perPage: pageSize)
        let (users2, info2) = try await sut.fetch(pageToken: info1.next!)
        let allIDs = (users1 + users2).map(\.id)
        XCTAssertEqual(Set(allIDs).count, sut.itemsPool.count)
        XCTAssertNil(info2.next)
    }

}
