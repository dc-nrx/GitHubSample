//
//  SwiftUIView.swift
//  
//
//  Created by Dmytro Chapovskyi on 28.06.2024.
//

import SwiftUI
import API
import Preview

struct RepoCell: View {
    
    var repo: Repo
    
    var descrLineLimit: Int
    
    init(
        _ repo: Repo,
        descrLineLimit: Int = 4
    ) {
        self.repo = repo
        self.descrLineLimit = descrLineLimit
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(repo.name)
                .font(.headline)
                .lineLimit(1)
            if let description = repo.description {
                Text(description)
                    .foregroundStyle(.secondary)
                    .lineLimit(descrLineLimit)
            }
            HStack(spacing: 12) {
                label(repo.stargazersCount, "star.fill")
                label(repo.forksCount, "arrow.triangle.branch")
                Spacer()
                if let language = repo.language {
                    Text(language)
                } else {
                    Text("Unknown")
                        .italic()
                        .foregroundStyle(.secondary)
                }
            }
            .lineLimit(1)
            .padding(.vertical, 4)
        }
    }

    /// `Label(text:systemImage:)` has too much spacing for this occasion.
    @ViewBuilder
    func label(
        _ value: Int,
        _ systemImage: String,
        _ spacing: CGFloat = 4
    ) -> some View {
        HStack(spacing: spacing) {
            Image(systemName: systemImage)
            Text("\(value)")
        }
    }
}

#Preview {
    List {
        ForEach(Samples.repos.dropFirst(5)) {
            RepoCell($0)
        }
    }
}
