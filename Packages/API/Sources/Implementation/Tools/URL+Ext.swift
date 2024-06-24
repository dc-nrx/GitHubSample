//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation

enum UrlConstructionError: Error {
    case componentsDecompositionFailed
    case unsupportedQueryItemType(Any)
    case failedBuildingUrl(URLComponents)
}

extension URL {
    
    //TODO: Test
    init(
        base: URL,
        path: String,
        query: [String: Any]
    ) throws {
        let fullUrl = base.appending(path: path)
        let queryItems = try query.map { key, value in
            let itemValue: String
            if let strValue = value as? String {
                itemValue = strValue
            } else if let intValue = value as? Int {
                itemValue = "\(intValue)"
            } else {
                throw UrlConstructionError.unsupportedQueryItemType(value)
            }
            return URLQueryItem(name: key, value: itemValue)
        }
        
        guard var components = URLComponents(url: fullUrl, resolvingAgainstBaseURL: false) else {
            throw UrlConstructionError.componentsDecompositionFailed
        }
        
        components.queryItems = queryItems
        guard let result = components.url else {
            throw UrlConstructionError.failedBuildingUrl(components)
        }
        
        self = result
    }
}
