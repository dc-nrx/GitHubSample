//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import SwiftUI

struct ActivityIndicator: View {
    
    var visible: Bool = false
    
    var body: some View {
        if visible {
            if #available(iOS 17.0, *) {
                Image(systemName: "square.stack.3d.up")
                    .symbolEffect(
                        .variableColor.cumulative,
                        options: .repeating)
                    .contentTransition(.symbolEffect(.replace))
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    ActivityIndicator(visible: true)
}
