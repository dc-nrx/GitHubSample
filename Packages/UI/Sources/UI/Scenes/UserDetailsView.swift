//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import SwiftUI

import SDWebImageSwiftUI

import API
import ViewModel
import Preview

struct UserDetailsView<P: UserReposPaginator>: View {
    
    var vm: UserDetailsVM<P>
    
    init(_ vm: UserDetailsVM<P>) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            userInfoView(vm.user)
            PaginatorLazyVStack(vm.reposPaginatorVM) { repo in
                RepoCell(repo)
                    .padding()
                Divider()
            }
        }
        .onAppear { vm.reposPaginatorVM.onAppear() }
        .navigationTitle(vm.user.login)
    }
    
    @ViewBuilder @MainActor
    func userInfoView(_ user: User) -> some View {
        HStack {
            RemoteImage(url: user.avatarUrl)
                .frame(minWidth: 0, maxWidth: .infinity)
            HStack {
                Text(vm.user.login)
                    .font(.callout)
                Text(user.bio)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

#Preview {
    let factory = ViewModelFactory(api: ApiMock())
    return NavigationStack {
        UserDetailsView(factory.makeUserDetailsVM(Samples.users[0]))
    }
}
