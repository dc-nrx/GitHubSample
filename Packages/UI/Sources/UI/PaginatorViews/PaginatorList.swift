//
//  UsersView.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import SwiftUI
import API
import ViewModel
import Preview
import SDWebImageSwiftUI

public struct PaginatorList<Api: Paginator, Content: View>: View {
    
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
        List {
            Section {
                ForEach(vm.items) { item in
                    content(item)
                        .onAppear { vm.itemShown(item) }
                }
            } footer: {
                if vm.showLoadingNextPage {
                    Text("Loading next page...")
                } else {
                    Text("No items left.")
                }
            }
        }
        .onAppear(perform: vm.onAppear)
        .refreshable {
            await vm.asyncRefresh()
        }
    }
}

#Preview {

    let vm = PaginatorVM(
//        UsersPaginatorMock(Samples.users.prefix(20),
        ReposPaginatorMock(Samples.repos,
                           nextDelay: 2),
        filter: .init(username: "username"),
        pageSize: 15
    )
    
    return NavigationStack {
        PaginatorList(vm) {
//            UserCell($0)
            RepoCell($0)
        }
    }
}
