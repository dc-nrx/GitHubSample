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

    func testAllPresent_normalOrder_parsedCorrectly() throws {
        let header = Samples.linkHeader()
        let sample = Samples.paginationInfo
        var sut = try UrlPaginationInfo(githubLinkHeader: header)
        XCTAssertEqual(sut, sample)
    }
    
    func testNextOnly_parsedCorrectly() throws {
        let header = Samples.linkHeader(prev: false, first: false, last: false)
        let sample = UrlPaginationInfo(next: Samples.paginationInfo.next)
        var sut = try UrlPaginationInfo(githubLinkHeader: header)
        XCTAssertEqual(sut, sample)
    }
    
    func testNextAndPrev_parsedCorrectly() throws {
        let header = Samples.linkHeader(first: false, last: false)
        let sample = UrlPaginationInfo(next: Samples.paginationInfo.next, prev: Samples.paginationInfo.prev)
        var sut = try UrlPaginationInfo(githubLinkHeader: header)
        XCTAssertEqual(sut, sample)
    }

    func testAllReversed_parsedCorrectly() throws {
        let header = Samples.linkHeader(reverseOrder: true)
        let sample = Samples.paginationInfo
        var sut = try UrlPaginationInfo(githubLinkHeader: header)
        XCTAssertEqual(sut, sample)
    }
    
    func testMissingSpace_afterSemicolon_hasNoImpact() throws {
        let header = Samples.linkHeader().replacingOccurrences(of: "; ", with: ";")
        let sample = Samples.paginationInfo
        var sut = try UrlPaginationInfo(githubLinkHeader: header)
        XCTAssertEqual(sut, sample)
    }
    
    // TODO: Add similar tests for `prev`, `last`, `next`.
    func testRepeatedNext_inFullHeader_throwsCorrectError() throws {
        let fullHeader = Samples.linkHeader()
        let extraHeader = Samples.linkHeader(prev: false, first: false, last: false)
        let header = [fullHeader, extraHeader].joined(separator: ", ")
        let sample = Samples.paginationInfo
        
        XCTAssertThrowsError(try UrlPaginationInfo(githubLinkHeader: header)) { error in
            if case let ApiError.duplicatePaginationLink(linkKey) = error {
                XCTAssertEqual(linkKey, "next")
            } else {
                XCTFail("Wrong error thrown \(error)")
            }
        }
    }
    
}
