//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 27.06.2024.
//

import Foundation

/**
 A single point of network access - responsible for auth, rate limits etc.
 */
public protocol SessionManager {
    
    func data(_ method: HttpMethod, from url: URL) async throws -> (Data, URLResponse)
    var authToken: String? { get set }
}

public enum HttpMethod: String {
    case get, post
}
