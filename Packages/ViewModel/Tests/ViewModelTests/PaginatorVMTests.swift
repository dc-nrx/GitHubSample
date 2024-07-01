import XCTest
import Combine

import Preview
import API
import ViewModel

final class PaginatorVMTests: XCTestCase {
    typealias Sut = PaginatorVM<UsersPaginatorMock>
        
    var sut: Sut!
    var mockPaginator: UsersPaginatorMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() async throws {
        cancellables = .init()
        mockPaginator = .init(firstDelay: 0.05, nextDelay: 0.05)
        sut = await .init(mockPaginator, filter: 0, pageSize: 30)
    }
    
    override func tearDown() async throws {
        mockPaginator = nil
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
            XCTAssertEqual(users.map(\.id), mockPaginator.itemsPool.prefix(sut.pageSize).map(\.id))
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
            XCTAssertEqual(users.map(\.id), mockPaginator.itemsPool.prefix(sut.pageSize * 2).map(\.id))
        }
        sut.itemShown(sut.items.last!)
        await fulfillment(of: [loadNextExp], timeout: 1)
    }
    
    @MainActor
    func testRefreshAfter2PagesLoaded_containFirstPageOnly() async {
        let onAppearExp = usersExpectation(sut)
        sut.onAppear()
        await fulfillment(of: [onAppearExp], timeout: 1)
        
        let nextPageExp = usersExpectation(sut)
        sut.explicitRequestNextPageFetch()
        await fulfillment(of: [nextPageExp], timeout: 1)
        
        await sut.asyncRefresh()
        XCTAssertEqual(sut.items.map(\.id), mockPaginator.itemsPool.prefix(sut.pageSize).map(\.id))
    }

    // TODO: Add tests with significatly delayed responses
    
    @MainActor
    func testStateDebounce_wihCorrectResultingValue() async {
        let exp = XCTestExpectation(description: "status is nextPageAvailable")
        sut.onAppear()
        sut.$nextPageLoadingStatus
            .dropFirst()    // .unknown
            .sink { status in
                XCTAssertEqual(status, .nextPageAvailable)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 1)
    }
    
    // TODO: Add state tests for different scenarios and bigger delay (so no transion is hidden behind debounce)
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
