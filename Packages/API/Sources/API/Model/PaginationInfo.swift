//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation

public protocol PaginationInfoProtocol {
    associatedtype Token
    
    var next: Token? { get }
    var prev: Token? { get }
    var first: Token? { get }
    var last: Token? { get }
}
