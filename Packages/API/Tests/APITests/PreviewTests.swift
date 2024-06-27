//
//  DecodableFromJsonFileTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import XCTest
import Preview
import API

final class PreviewTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDecodeUsers_fromJson_correctCount() throws {
        let sut = [User](jsonFile: "users70_page1")
        XCTAssertEqual(sut.count, 70)
    }
    
    func testSampleUsers_hasCorrectCount() {
        let sut = Samples.users
        XCTAssertEqual(sut.count, 140)
    }
    
    func testGithubApiMock_loadsFirst20Correctly() async throws {
        let sut = GitHubAPIMock()
        let (users, info) = try await sut.fetch(since: 0, perPage: 20)
        XCTAssertEqual(users.count, 20)
    }
    
    func testGithubApiMock_loadsFirst30Correctly() async throws {
        let sut = GitHubAPIMock()
        let (users, info) = try await sut.fetch(since: 0, perPage: 30)
        XCTAssertEqual(users.count, 30)
    }
    
    func testGithubApiMock_loadsFirstTwoPages30_allUnique() async throws {
        let sut = GitHubAPIMock()
        let (users1, info1) = try await sut.fetch(since: 0, perPage: 30)
        let (users2, info2) = try await sut.fetch(pageToken: info1.next!)
        let allIDs = (users1 + users2).map(\.id)
        XCTAssertEqual(Set(allIDs).count, 60)
    }

    func testGithubApiMock_loadsOversizePage_noOverflow_nextIsNil() async throws {
        let sut = GitHubAPIMock()
        let (users, info) = try await sut.fetch(since: 0, perPage: 400)
        XCTAssertEqual(users.count, sut.usersPool.count)
        XCTAssertNil(info.next)
    }

    func testGithubApiMock_loads2GrandPages_noOverflow_nextIsNil() async throws {
        let sut = GitHubAPIMock()
        let pageSize = sut.usersPool.count / 2 + 2
        let (users1, info1) = try await sut.fetch(since: 0, perPage: pageSize)
        let (users2, info2) = try await sut.fetch(pageToken: info1.next!)
        let allIDs = (users1 + users2).map(\.id)
        XCTAssertEqual(Set(allIDs).count, sut.usersPool.count)
        XCTAssertNil(info2.next)
    }

}
