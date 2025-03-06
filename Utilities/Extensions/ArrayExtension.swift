//
//  ArrayExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-11-14.
//

import Foundation

extension Array where Element: Any {

    func get(_ index: Int) -> Element? {
        if index < count {
            return self[index]
        } else {
            return nil
        }
    }
    
    func chunked(into size: Int = 3) -> [[Element]] {
        guard size > 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
