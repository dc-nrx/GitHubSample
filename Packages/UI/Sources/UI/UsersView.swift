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
import SDWebImageSwiftUI

public struct UsersView<Api: PaginationAPI>: View where Api.Item == User {
    
    @ObservedObject 
    var vm: PaginatorVM<Api>
    
    @State var imageSide: CGFloat = 64
    
    public init(vm: PaginatorVM<Api>) {
        self.vm = vm
    }
    
    public var body: some View {
        List {
            Section {
                ForEach(vm.items) { item in
                    cell(item)
                        .onAppear { vm.itemShown(item) }
                }
            }
        }
        .onAppear(perform: vm.onAppear)
        .refreshable {
            await vm.asyncRefresh()
        }
        .navigationTitle("Users")
        .toolbar {
            ConnectionIcon(vm.connectionState)
                .animation(.default, value: vm.connectionState)
        }
    }
    
    @ViewBuilder
    func cell(_ user: User) -> some View {
        HStack {
            WebImage(url: user.avatarUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSide, height: imageSide)
                    .shadow(radius: 2)
            } placeholder: {
                Image(systemName: "photo")
            }
            .background(.yellow)
            
            VStack(alignment: .leading) {
                Text("id: \(user.id)")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(user.login)
                    .foregroundStyle(.primary)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    let vm = PaginatorVM(
        api: GitHubAPIMock(nextDelay: 2),
        referenceID: 0,
        pageSize: 30
    )
    
    return NavigationStack {
        UsersView(vm: vm)
    }
}
