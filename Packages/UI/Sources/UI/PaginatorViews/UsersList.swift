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
        PaginatorList(vm) { user in
            NavigationLink(value: user) {
                UserCell(user)
            }
        }
        .navigationDestination(for: User.self) { user in
            
        }
    }
}

#Preview {
    let factory = ViewModelFactory(api: ApiMock())
    return UsersList(factory.makeUsersVM())
}
