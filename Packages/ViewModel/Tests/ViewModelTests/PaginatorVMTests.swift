import XCTest
import Combine

import Preview
import API
@testable import ViewModel

final class PaginatorVMTests: XCTestCase {
    typealias Sut = PaginatorVM<GitHubAPIMock>
        
    var sut: Sut!
    var mockApi: GitHubAPIMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() async throws {
        cancellables = .init()
        mockApi = .init()
        sut = await .init(api: mockApi, referenceID: 0, pageSize: 30)
    }
    
    override func tearDown() async throws {
        mockApi = nil
        sut = nil
        cancellables = nil
    }
    
    @MainActor
    func testInitialState() {
        XCTAssertTrue(sut.items.isEmpty)
    }
    
    @MainActor
    func testInitialLoad_loadsFirstPage() async {
        let exp = usersExpectation(sut, dropFirst: 1) { [self] users in
            XCTAssertEqual(users.map(\.id), mockApi.usersPool.prefix(sut.pageSize).map(\.id))
        }
        sut.onAppear()
        await fulfillment(of: [exp], timeout: 1)
    }

    @MainActor
    func testInitialLoad_loadsNextPage() async {
        let onAppearExp = usersExpectation(sut)
        sut.onAppear()
        await fulfillment(of: [onAppearExp], timeout: 1)
        
        let loadNextExp = usersExpectation(sut) { [self] users in
            XCTAssertEqual(users.map(\.id), mockApi.usersPool.prefix(sut.pageSize * 2).map(\.id))
        }
        sut.itemShown(sut.items.last!)
        await fulfillment(of: [loadNextExp], timeout: 1)
    }
}

private extension PaginatorVMTests {
    
    @MainActor
    func usersExpectation(
        _ vm: Sut,
        dropFirst: Int = 1,
        sink: (([User]) -> ())? = nil
    ) -> XCTestExpectation {
        let exp = XCTestExpectation(description: "usersExpectation; drop first \(dropFirst)")
        vm.$items
            .dropFirst(dropFirst)
            .sink {
                sink?($0)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        return exp
    }
}
