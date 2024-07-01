//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 01.07.2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Preview

struct RemoteImage: View {
    
    let url: URL?
    let imageSide: CGFloat? = nil
    
    var body: some View {
        WebImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSide, height: imageSide)
                .clipped(antialiased: true)
                .shadow(radius: 2)
        } placeholder: {
            Rectangle()
                .frame(width: imageSide, height: imageSide)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    RemoteImage(url: Samples.users.first?.avatarUrl)
}
