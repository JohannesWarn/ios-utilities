//
//  UtilitiesApp.swift
//  Utilities
//
//  Created by Johannes Wärn on 2025-03-06.
//

import SwiftUI

@main
struct UtilitiesApp: App {
    init() {
        setupURLCache()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func setupURLCache() {
        let megabyte = 1024 * 1024
        
        let fileManager = FileManager.default
        let customCacheDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("http-cache")
        try! fileManager.createDirectory(at: customCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        URLCache.shared = URLCache(
            memoryCapacity: 100 * megabyte,
            diskCapacity: 100 * megabyte,
            diskPath: customCacheDirectory.path
        )
    }
}
