//
//  UserCell.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import SwiftUI
import API
import SDWebImageSwiftUI
import Preview

struct UserCell: View {
    
    var user: User

    var imageSide: CGFloat

    init(_ user: User, imageSide: CGFloat = 64) {
        self.user = user
        self.imageSide = imageSide
    }
    
    var body: some View {
        HStack {
            WebImage(url: user.avatarUrl) { image in
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
            
            VStack(alignment: .leading) {
                Text("id: \(user.id)")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(user.login)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    List {
        ForEach(Samples.users) {
            UserCell($0)
        }
    }
}
