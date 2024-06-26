//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import Foundation

public enum ConnectionState: Equatable {
    case inactive
    case active
    case noConnection
    case error(String)
}
