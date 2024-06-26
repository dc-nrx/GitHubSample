//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import Foundation
import Implementation

public extension Decodable {
    
    init(jsonFile: String) {
        self = Self.fromJsonFile(jsonFile)
    }
    
    static func fromJsonFile(_ name: String) -> Self {
        let url = Bundle.module.url(forResource: name, withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return try! JSONDecoder(keyStrategy: .convertFromSnakeCase).decode(Self.self, from: data)
    }
}
