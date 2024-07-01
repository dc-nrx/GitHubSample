//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 01.07.2024.
//

import Foundation

public enum PaginatorViewModelState {
    case unknown
    
    case initialFetch, refreshing, fetchingNextPage

    case empty, nextPageAvailable, nextPageNotAvailable
}
