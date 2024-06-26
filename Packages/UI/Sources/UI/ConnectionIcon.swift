//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import SwiftUI
import ViewModel

struct ConnectionIcon: View {
    
    var state: ConnectionState
    
    init(_ state: ConnectionState) {
        self.state = state
    }
    
    var body: some View {
        if #available(iOS 17.0, *), case .active = state {
            iconView
                .symbolEffect(.pulse)
        } else {
            iconView
        }
    }
    
    @ViewBuilder
    private var iconView: some View {
        Image(systemName: symbolName)
            .symbolRenderingMode(.palette)
            .foregroundStyle(foreground, .blue, .clear)
            .opacity(opacity)
    }

    private var symbolName: String {
        switch state {
        case .inactive: "icloud"
        case .active: "icloud"
        case .noConnection: "icloud.slash"
        case .error: "xmark.icloud"
        }
    }
    
    private var foreground: Color {
        switch state {
        case .inactive: .blue
        case .active: .blue
        case .noConnection: .yellow
        case .error: .red
        }
    }
    
    private var opacity: CGFloat {
        switch state {
        case .inactive: 0
        default: 1
        }
    }

}

#Preview {
    VStack(spacing: 16) {
        ConnectionIcon(.active)
        ConnectionIcon(.inactive)
        ConnectionIcon(.noConnection)
        ConnectionIcon(.error("error :c"))
    }
    .font(.largeTitle)
}
