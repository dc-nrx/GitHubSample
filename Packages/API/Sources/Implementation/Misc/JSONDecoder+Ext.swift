//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 24.06.2024.
//

import Foundation

public extension JSONDecoder {
    
    convenience init(
        keyStrategy: JSONDecoder.KeyDecodingStrategy,
        date dataStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    ) {
        self.init()
        self.dateDecodingStrategy = dataStrategy
        self.keyDecodingStrategy = keyStrategy
    }
}
