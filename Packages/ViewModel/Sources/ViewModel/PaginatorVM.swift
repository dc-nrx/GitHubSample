// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import SwiftUI
import API

@MainActor
public class PaginatorVM<API: PaginationAPI>: ObservableObject {
    public typealias Item = API.Item
    
    @Published
    public var items = [Item]()
    
    @Published
    public var showRefreshControl = false

    @Published
    public var showLoadingNextPage = false
    
    @Published
    public var errorMessage: String?

    public var prefetchDistance: Int
    
    public private(set) var pageSize: Int
    public private(set) var referenceID: Item.ID
    
    private let api: API
    private var nextPage: API.PaginationInfo.Token?
    private var fetchTask: Task<Void, Never>?
    
    public init(
        api: API,
        referenceID: Item.ID,
        pageSize: Int,
        distanceBeforePrefetch: Int = 10
    ) {
        print("init")
        self.api = api
        self.prefetchDistance = distanceBeforePrefetch
        self.referenceID = referenceID
        self.pageSize = pageSize
    }
}

public extension PaginatorVM {
    
    func onAppear() {
        if items.isEmpty {
            requestRefresh()
        }
    }

    func asyncRefresh() async {
        requestRefresh()
        _ = await fetchTask?.result
    }

    func itemShown(_ item: Item) {
        if items.suffix(prefetchDistance).contains(item) {
            requestNextPageFetch()
        }
    }
    
    // TODO: Support refetch last page
}

private extension PaginatorVM {
    
    func requestNextPageFetch() {
        guard fetchTask == nil else { return }
        guard let nextPage else { return }
        showLoadingNextPage = true
        
        fetchTask = Task { @BackgroundActor [weak self] in
            guard let self else { return }
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
        }
    }
    
    func requestRefresh() {
        guard fetchTask == nil else { return }
        showRefreshControl = true
        
        fetchTask = Task { @BackgroundActor [weak self] in
            guard let self else { return }
            do {
                let response = try await api.fetch(since: referenceID, perPage: pageSize)
                await pageReceived(response, rewriteItems: true)
            } catch {
                await process(error: error)
            }
            await MainActor.run {
                self.fetchTask = nil
            }
        }
    }
    
    func pageReceived(
        _ page: ([Item], API.PaginationInfo),
        rewriteItems: Bool
    ) {
        if rewriteItems {
            self.items = page.0
        } else {
            self.items.append(contentsOf: page.0)
        }
        nextPage = page.1.next
    }
    
    func process(error: Error) {
        self.errorMessage = "Error occured: \(error)"
    }
}

extension RandomAccessCollection where Element: Identifiable {
    
    func contains(_ item: Element) -> Bool {
        contains { $0.id == item.id }
    }
}
