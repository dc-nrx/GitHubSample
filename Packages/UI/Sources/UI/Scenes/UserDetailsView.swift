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

struct UserDetailsView<API: GitHubAPI>: View {
    
    @ObservedObject
    var vm: UserDetailsVM<API>
    
    @State var imageExtended = false
    
    init(_ vm: UserDetailsVM<API>) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            headerView(vm.user)
            VStack(alignment: .leading) {
                Text("Repos list:")
                    .font(.headline)
                    .frame(idealWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Divider()
            }
            PaginatorVStack(vm.reposPaginatorVM) { repo in
                NavigationLink {
                    Text("\(repo.url)")
                } label: {
                    RepoCell(repo)
                        .padding()
                        .background()
                }
                .buttonStyle(PlainButtonStyle())
                Divider()
            }
        }
        .animation(.bouncy(), value: imageExtended)
        .task { await vm.onAppear() }
        .refreshable(action: vm.refresh)
        .navigationTitle(vm.user.login)
    }
    
    var headerLayout: AnyLayout {
        imageExtended ? AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout())
    }
    
    @ViewBuilder
    func headerView(_ user: User) -> some View {
        VStack(alignment: .leading) {
            headerLayout {
                avatarView(user)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, imageExtended ? 0 : 8)
                    .animation(.bouncy, value: imageExtended)
                mainDetails(user)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            extraDetails(user)
                .padding()
        }
    }
    
    @ViewBuilder
    func avatarView(_ user: User) -> some View {
        RemoteImage(url: user.avatarUrl)
            .frame(minWidth: 0, maxWidth: .infinity)
            .onTapGesture {
                withAnimation {
                    imageExtended.toggle()
                }
            }

    }

    @ViewBuilder
    func mainDetails(_ user: User) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let name = user.name {
                Text(name)
                    .font(.headline)
                    .lineLimit(2)
            }
            if let followers = user.followers {
                Label("\(followers)", systemImage: "person.2")
            }
            if let following = user.following {
                Label("\(following)", systemImage: "figure.walk.circle")
            }
            Label("\(user.id)", systemImage: "grid.circle")
            Spacer()
        }
    }

    @ViewBuilder
    func extraDetails(_ user: User) -> some View {
        VStack(alignment: .leading) {
            if let bio = user.bio {
                Text("Bio")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(12)
                Text(bio)
            }
        }
    }
}

#Preview {
    let factory = ViewModelFactory(api: ApiMock(repos: .init(firstDelay: 0.3)))
    return NavigationStack {
        UserDetailsView(factory.makeUserDetailsVM(Samples.users[2]))
    }
}
