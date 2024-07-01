//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import SwiftUI
import ViewModel

struct PaginatorVMStateView: View {
    
    let status: PaginatorViewModelState
    let action: () -> Void
    
    init(_ status: PaginatorViewModelState, action: @escaping () -> Void) {
        self.status = status
        self.action = action
    }
    
    var body: some View {
        switch status {
        case .unknown:
            EmptyView()
        case .initialFetch:
            Text("Fetching first page...")
        case .refreshing:
            Text("Refreshing...")
        case .fetchingNextPage:
            Text("Loading next page...")
        case .nextPageAvailable:
            Button("Load next") { action() }
        case .nextPageNotAvailable:
            Text("Nothing left to fetch.")
        case .empty:
            Text("Empty")
        }
    }
}

#Preview {
    VStack {
        PaginatorVMStateView(.nextPageAvailable) { }
        PaginatorVMStateView(.nextPageNotAvailable) { }
        PaginatorVMStateView(.fetchingNextPage) { }
        PaginatorVMStateView(.refreshing) { }
        PaginatorVMStateView(.initialFetch) { }
        PaginatorVMStateView(.empty) { }
        PaginatorVMStateView(.unknown) { }
    }
}
