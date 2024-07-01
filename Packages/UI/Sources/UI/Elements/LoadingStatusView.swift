//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import SwiftUI
import ViewModel

struct LoadingStatusView: View {
    
    let status: NextPageInfo
    let action: () -> Void
    
    init(_ status: NextPageInfo, action: @escaping () -> Void) {
        self.status = status
        self.action = action
    }
    
    var body: some View {
        switch status {
        case .unknown:
            EmptyView()
        case .available:
            Button("Load next") { action() }
        case .fetching:
            Text("Loading next page...")
        case .notAvailable:
            Text("Nothing left to fetch.")
        }
    }
}

#Preview {
    VStack {
        LoadingStatusView(.available) { }
        LoadingStatusView(.fetching) { }
        LoadingStatusView(.notAvailable) { }
        LoadingStatusView(.unknown) { }
    }
}
