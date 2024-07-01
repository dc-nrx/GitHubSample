//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import SwiftUI
import ViewModel
import API
import Preview

public struct UsersList<API: GitHubAPI>: View {
    
    @ObservedObject
    public var vm: UsersListVM<API>
    
    public init(_ vm: UsersListVM<API>) {
        self.vm = vm
    }
    
    public var body: some View {
        List {
            Section {
                PaginatorList(vm) { user in
                    NavigationLink {
                        Text(user.login)
                    } label: {
                        UserCell(user)
                    }
                }
            } footer: {
//                if vm.showLoadingNextPage {
//                    Text("Loading next page...")
//                } else {
                    Text("No items left.")
//                }
            }
        }
//        .navigationDestination(for: User.self) { user in
//            Text("xxx")
//        }
    }
}

#Preview {
    let factory = ViewModelFactory(api: ApiMock())
    return NavigationStack {
        UsersList(factory.makeUsersVM())
    }
}
