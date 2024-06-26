//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 26.06.2024.
//

import Foundation

@globalActor
public struct BackgroundActor {
  public actor BackgroundActor { }

  public static let shared = BackgroundActor()
}
