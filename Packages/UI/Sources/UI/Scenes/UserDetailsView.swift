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
    
    @State var imageExtended = false
    
    init(_ vm: UserDetailsVM<P>) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            headerView(vm.user)
            PaginatorLazyVStack(vm.reposPaginatorVM) { repo in
                RepoCell(repo)
                    .padding()
                Divider()
            }
        }
        .animation(.bouncy(), value: imageExtended)
        .onAppear { vm.reposPaginatorVM.onAppear() }
        .navigationTitle(vm.user.login)
    }
    
    @ViewBuilder @MainActor
    func headerView(_ user: User) -> some View {
        VStack(alignment: .leading) {
            HStack {
                avatarView
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(imageExtended ? 0 : 8)
                    .animation(.bouncy, value: imageExtended)
                if !imageExtended {
                    mainDetailsView(user)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
            VStack(alignment: .leading) {
                if let bio = user.bio {
                    Text("Bio")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(bio)
                }
                Text("Repos list:")
                    .font(.headline)
                    .frame(alignment: .leading)
                    .padding(.top, 16)
                Divider()
            }
            .frame(idealWidth: .infinity)
            .padding()
        }
    }
    
    @ViewBuilder @MainActor
    func mainDetailsView(_ user: User) -> some View {
        VStack(alignment: .leading) {
            Text(user.login)
                .font(.callout)
        }
    }
    
    @ViewBuilder @MainActor
    var avatarView: some View {
        RemoteImage(url: vm.user.avatarUrl)
            .frame(minWidth: 0, maxWidth: .infinity)
            .onTapGesture {
                withAnimation {
                    imageExtended.toggle()
                }
            }

    }
}

#Preview {
    let factory = ViewModelFactory(api: ApiMock())
    return NavigationStack {
        UserDetailsView(factory.makeUserDetailsVM(Samples.userDetails))
    }
}
