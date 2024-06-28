//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import SwiftUI
import API
import ViewModel
import Preview

struct UserDetailsView<P: UserReposPaginator>: View {
    
    var vm: UserDetailsVM<P>
    
    init(_ vm: UserDetailsVM<P>) {
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Text(vm.user.login)
                .font(.callout)
            PaginatorList(vm.reposPaginatorVM) { repo in
                RepoCell(repo)
            }
            .ignoresSafeArea()
        }
        .onAppear { vm.reposPaginatorVM.onAppear() }
        .navigationTitle(vm.user.login)
    }
}

#Preview {
    let factory = ViewModelFactory(api: ApiMock())
    return NavigationStack {
        UserDetailsView(factory.makeUserDetailsVM(Samples.users[0]))
    }
}
