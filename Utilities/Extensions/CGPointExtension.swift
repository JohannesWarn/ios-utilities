//
//  CGPointExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-11-07.
//

import Foundation

infix operator *: MultiplicationPrecedence

extension CGPoint {
    static func * (point: CGPoint, factor: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * factor, y: point.y * factor)
    }
    
    static func * (factor: CGFloat, point: CGPoint) -> CGPoint {
        return point * factor
    }

    static func *= (point: inout CGPoint, factor: CGFloat) {
        point = point * factor
    }
}
