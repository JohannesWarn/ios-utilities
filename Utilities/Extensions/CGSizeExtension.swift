//
//  CGSizeExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-11-07.
//

import Foundation

infix operator *: MultiplicationPrecedence

extension CGSize {
    static func * (size: CGSize, factor: CGFloat) -> CGSize {
        return CGSize(width: size.width * factor, height: size.height * factor)
    }
    
    static func * (factor: CGFloat, size: CGSize) -> CGSize {
        return size * factor
    }

    static func *= (size: inout CGSize, factor: CGFloat) {
        size = size * factor
    }
}
