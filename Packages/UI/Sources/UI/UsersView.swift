//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import SwiftUI
import API
import ViewModel
import Preview

struct UsersView<Api: PaginationAPI>: View where Api.Item == User {
    
    @ObservedObject 
    var vm: PaginatorVM<Api>
    
    var body: some View {
        List(vm.items) { item in
            Text(item.login)
                .onAppear {
                    vm.itemShown(item)
                }
        }
        .onAppear(perform: vm.onAppear)
    }
}

#Preview {
    UsersView(vm: .init(api: GitHubAPIMock(), referenceID: 0, pageSize: 30))
}
