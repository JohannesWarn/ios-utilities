//
//  DateExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-10-24.
//

import Foundation

extension Date {
    
    func isFuture() -> Bool {
        return self > Date()
    }

    func isPast() -> Bool {
        return self < Date()
    }
    
    static let animationsStartDate = Date()
    
}
