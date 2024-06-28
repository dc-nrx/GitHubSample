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
            HStack {
                // `Label(text:systemImage:)` has too much spacing for this occasion.
                Image(systemName: "star.fill")
                Text("\(repo.stargazersCount)")
                
                Image(systemName: "arrow.triangle.branch")
                Text("\(repo.forksCount)")
                
                Spacer()
                if let language = repo.language {
                    Text(language)
                        .italic()
                }
            }
            .padding(.vertical, 4)
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
