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

}
