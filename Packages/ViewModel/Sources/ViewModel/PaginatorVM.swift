// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import OSLog
import Network

import SwiftUI
import API

@MainActor
public class PaginatorVM<P: Paginator>: ObservableObject {
    public typealias Item = P.Item
    
    @Published
    public private(set) var items = [Item]()
    
    @Published
    public private(set) var isRefreshing = false

    @Published
    public private(set) var nextPageLoadingStatus: NextPageInfo = .unknown
    
    @Published
    public private(set) var errorMessage: String?

    public private(set) var pageSize: Int
    public private(set) var filter: P.Filter

    /**
     Maximum distance between the last visible item and the end of the list
     before  triggering next page fetch.
     
     If `nil`, no fetch on `itemShown` event will ever be triggered.
     */
    public var prefetchDistance: Int?
        
    private let paginator: P
    private let logger = Logger(subsystem: "ViewModel", category: "PaginatorVM<\(P.self)")
    
    @Published
    private var nextPage: P.PaginationInfo.Token?
    
    @Published
    private var fetchTask: Task<Void, Never>?
    
    public init(
        _ paginator: P,
        filter: P.Filter,
        pageSize: Int,
        prefetchDistance: Int? = 3
    ) {
        logger.debug("init")
        self.paginator = paginator
        self.prefetchDistance = prefetchDistance
        self.filter = filter
        self.pageSize = pageSize
        
        scheduleNextPageInfoUpdates()
    }
}

public extension PaginatorVM {
    
    func onAppear() {
        logger.info(#function)
        if items.isEmpty {
            requestRefresh()
        }
    }

    /**
     The method is made `async` for convenient use in conjecture with `refreshable`.
     */
    func asyncRefresh() async {
        logger.info(#function)
        requestRefresh()
        _ = await fetchTask?.result
        logger.info("\(#function): finished")
    }

    /**
     Call this method upon showing a cell representing the `item`.
     This will trigger next page fetch at the moment determined by `prefetchDistance`.
     If `prefetchDistance == nil`, this method can be ignored.
     
     - Warning: Be wary that when used in SwiftUI, in certain cases the `onAppear`
     modifier (a natural place to call this method from) might not get triggered itself.
     (e.g., when refreshing with a small `pageSize`).
     Therefore, it is advisable to have a fallback option to fetch the next page 
     (see `explicitRequestNextPageFetch`)
     */
    func itemShown(_ item: Item) {
        let itemId = "\(item.id)"
        logger.info("item shown; id = \(itemId)")
        
        if let prefetchDistance,
           items.suffix(prefetchDistance).contains(item) {
            requestNextPageFetch()
        }
    }
    
    func explicitRequestNextPageFetch() {
        requestNextPageFetch()
    }
    
    // TODO: Support refetch last page
}

private extension PaginatorVM {
    
    func requestNextPageFetch() {
        logger.info(#function)
        guard fetchTask == nil else { return }
        guard let nextPage else { return }
        
        logger.debug("next page fetch initiated")
        fetchTask = Task { @BackgroundActor [weak self] in
            guard let self else { return }
            logger.debug("fetch task started")
            
            do {
                let response = try await paginator.fetch(pageToken: nextPage)
                await pageReceived(response, rewriteItems: false)
            } catch {
                await process(error: error)
            }
            
            logger.debug("fetch task finished")
        }
    }
    
    func requestRefresh() {
        logger.info(#function)
        guard fetchTask == nil else { return }
        isRefreshing = true
        
        logger.debug("refresh initiated")
        fetchTask = Task { @BackgroundActor [weak self] in
            guard let self else { return }
            logger.debug("refresh task started")
            
            do {
                let response = try await paginator.fetch(filter, perPage: pageSize)
                await pageReceived(response, rewriteItems: true)
            } catch {
                await process(error: error)
            }
            
            await MainActor.run {
                self.isRefreshing = false
            }
            logger.debug("refresh task finished")
        }
    }
    
    func pageReceived(
        _ page: ([Item], P.PaginationInfo),
        rewriteItems: Bool
    ) {
        let nextPageString = "\(String(describing: page.1.next))"
        logger.info("page received. items = \(page.0), next page = \(nextPageString)")
        
        fetchTask = nil
        nextPage = page.1.next
        withAnimation {
            if rewriteItems {
                self.items = page.0
            } else {
                self.items.append(contentsOf: page.0)
            }
        }
    }
    
    func process(error: Error) {
        logger.warning("processing error: \(error)")
        
        fetchTask = nil
        withAnimation {
            self.errorMessage = "Error occured: \(error)"
        }
    }
    
    func scheduleNextPageInfoUpdates() {
        Publishers.CombineLatest3(
            $fetchTask.map { $0 != nil },
            $isRefreshing,
            $nextPage.map { $0 != nil }
        ).map { fetching, isRefresh, nextPageAvailable in
            switch (fetching, isRefresh) {
            case (true, false):
                .fetching
            case (true, true):
                .unknown
            case (false, false):
                nextPageAvailable ? .available : .notAvailable
            default:
                .unknown
            }
        }
        .assign(to: &$nextPageLoadingStatus)
    }
}

extension RandomAccessCollection where Element: Identifiable {
    
    func contains(_ item: Element) -> Bool {
        contains { $0.id == item.id }
    }
}
