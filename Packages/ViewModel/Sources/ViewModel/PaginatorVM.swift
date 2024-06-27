// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import OSLog
import Network

import SwiftUI
import API

@MainActor
public class PaginatorVM<API: Paginator>: ObservableObject {
    public typealias Item = API.Item
    
    @Published
    public var items = [Item]()
    
    @Published
    public var showRefreshControl = false

    @Published
    public var showLoadingNextPage = false
    
    @Published
    public var errorMessage: String?

    @Published
    public var connectionState: ConnectionState = .inactive
    
    public var prefetchDistance: Int
    
    public private(set) var pageSize: Int
    public private(set) var filter: API.Filter
    
    private let api: API
    private let pathMonitor: NWPathMonitor
    private let logger = Logger(subsystem: "ViewModel", category: "PaginatorVM<\(API.self)")
    
    private var nextPage: API.PaginationInfo.Token?
    private var fetchTask: Task<Void, Never>? {
        willSet {
            let newState: ConnectionState = (newValue == nil) ? .inactive : .active
            connectionStateTransition(to: newState)
        }
    }
    
    public init(
        api: API,
        filter: API.Filter,
        pageSize: Int,
        pathMonitor: NWPathMonitor = .init(),
        distanceBeforePrefetch: Int = 10
    ) {
        logger.debug("init")
        self.api = api
        self.prefetchDistance = distanceBeforePrefetch
        self.filter = filter
        self.pageSize = pageSize
        self.pathMonitor = pathMonitor
        
        self.observeNetworkChanges()
    }
}

public extension PaginatorVM {
    
    func onAppear() {
        logger.info(#function)
        if items.isEmpty {
            requestRefresh()
        }
    }

    func asyncRefresh() async {
        logger.info(#function)
        requestRefresh()
        _ = await fetchTask?.result
        logger.info("\(#function): finished")
    }

    func itemShown(_ item: Item) {
        let itemId = "\(item.id)"
        logger.info("item shown; id = \(itemId)")
        
        if items.suffix(prefetchDistance).contains(item) {
            requestNextPageFetch()
        }
    }
    
    // TODO: Support refetch last page
}

private extension PaginatorVM {
    
    func requestNextPageFetch() {
        logger.info(#function)
        guard fetchTask == nil else { return }
        guard let nextPage else { return }
        showLoadingNextPage = true
        
        logger.debug("next page fetch initiated")
        fetchTask = Task { @BackgroundActor [weak self] in
            guard let self else { return }
            logger.debug("fetch task started")
            
            do {
                let response = try await api.fetch(pageToken: nextPage)
                await pageReceived(response, rewriteItems: false)
            } catch {
                await process(error: error)
            }
            await MainActor.run {
                self.showLoadingNextPage = false
                self.fetchTask = nil
            }
            logger.debug("fetch task finished")
        }
    }
    
    func requestRefresh() {
        logger.info(#function)
        guard fetchTask == nil else { return }
        showRefreshControl = true
        
        logger.debug("refresh initiated")
        fetchTask = Task { @BackgroundActor [weak self] in
            guard let self else { return }
            logger.debug("refresh task started")
            
            do {
                let response = try await api.fetch(filter, perPage: pageSize)
                await pageReceived(response, rewriteItems: true)
            } catch {
                await process(error: error)
            }
            await MainActor.run {
                self.fetchTask = nil
            }
            logger.debug("refresh task finished")
        }
    }
    
    func pageReceived(
        _ page: ([Item], API.PaginationInfo),
        rewriteItems: Bool
    ) {
        let nextPageString = "\(String(describing: page.1.next))"
        logger.info("page received. items = \(page.0), next page = \(nextPageString)")
        
        withAnimation {
            if rewriteItems {
                self.items = page.0
            } else {
                self.items.append(contentsOf: page.0)
            }
        }
        nextPage = page.1.next
    }
    
    func process(error: Error) {
        logger.warning("processing error: \(error)")
        withAnimation {
            self.errorMessage = "Error occured: \(error)"
        }
    }
    
    func connectionStateTransition(to newState: ConnectionState) {
        let newStateString = "\(newState)"
        logger.debug("connection state transition to `\(newStateString)`")
        
        withAnimation {
            connectionState = newState
        }
    }
    
    func observeNetworkChanges() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            if path.availableInterfaces.isEmpty {
                connectionStateTransition(to: .noConnection)
            } else if case .noConnection = self.connectionState {
                connectionStateTransition(to: .inactive)
            }
        }
    }
}

extension RandomAccessCollection where Element: Identifiable {
    
    func contains(_ item: Element) -> Bool {
        contains { $0.id == item.id }
    }
}
