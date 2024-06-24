//
//  UrlPaginationInfoTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import XCTest
@testable import Implementation

final class UrlPaginationInfoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var sut = try UrlPaginationInfo(githubLinkHeader: Samples.linkHeader())
        let sample = Samples.paginationInfo
        XCTAssertEqual(sut, sample)
    }

}
