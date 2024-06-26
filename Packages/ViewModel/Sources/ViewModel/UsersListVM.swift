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
    
    init(
        api: API,
        referenceID: Item.ID,
        pageSize: Int,
        distanceBeforePrefetch: Int = 10
    ) {
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
    
    func onRefresh() {
        requestRefresh()
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
        
        fetchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let (newItems, paginationInfo) = try await api.fetch(pageToken: nextPage)
                self.items.append(contentsOf: newItems)
                self.nextPage = paginationInfo.next
            } catch {
                self.errorMessage = "Error occured: \(error)"
            }
            self.fetchTask = nil
            showLoadingNextPage = false
        }
    }
    
    func requestRefresh() {
        guard fetchTask == nil else { return }
        showRefreshControl = true
        
        fetchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let (newItems, paginationInfo) = try await api.fetch(since: referenceID, perPage: pageSize)
                self.items = newItems
                self.nextPage = paginationInfo.next
            } catch {
                self.errorMessage = "Error occured: \(error)"
            }
            self.fetchTask = nil
            showRefreshControl = false
        }
    }
}

extension RandomAccessCollection where Element: Identifiable {
    
    func contains(_ item: Element) -> Bool {
        contains { $0.id == item.id }
    }
}
