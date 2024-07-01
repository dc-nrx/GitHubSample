//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 01.07.2024.
//

import SwiftUI

struct ErrorView: View {
    
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("An error occured:", systemImage: "exclamationmark.triangle.fill")
            Text(message)
                .lineLimit(4)
        }
        .foregroundStyle(.yellow)
    }
}

#Preview {
    ErrorView("something has happened")
}
