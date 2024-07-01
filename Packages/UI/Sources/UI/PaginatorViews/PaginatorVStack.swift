//
//  UsersView.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import SwiftUI

import SDWebImageSwiftUI

import API
import ViewModel
import Preview

/**
 A LazyVStack that handles `itemShown` and `fetchState`.
 
 - Warning: You still have to handle `vm.onAppear` and  `asyncRefresh` via enclosing container.
 */
public struct PaginatorVStack<Api: Paginator, Content: View>: View {
    
    @ObservedObject 
    public var vm: PaginatorVM<Api>
    
    @State 
    public var imageSide: CGFloat = 64
    
    private var content: (Api.Item) -> Content
    
    public init(
        _ vm: PaginatorVM<Api>,
        @ViewBuilder content: @escaping (Api.Item) -> Content
    ) {
        self.vm = vm
        self.content = content
    }
    
    public var body: some View {
        LazyVStack {
            ForEach(vm.items) { item in
                content(item)
                    .onAppear { vm.itemShown(item) }
            }
            PaginatorVMStateView(vm.fetchState) {
                vm.explicitRequestNextPageFetch()
            }
            .padding(.top)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {

    let vm = PaginatorVM(
//        UsersPaginatorMock(Samples.users.prefix(20),
        ReposPaginatorMock(Samples.repos,
                           nextDelay: 2),
        filter: .init(username: "username"),
        pageSize: 20
    )
    
    return NavigationStack {
        ScrollView {
            PaginatorVStack(vm) {
                //            UserCell($0)
                RepoCell($0)
            }
        }
        .onAppear(perform: vm.onAppear)
        .refreshable {
            await vm.asyncRefresh()
        }
    }
}
