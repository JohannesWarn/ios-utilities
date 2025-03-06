//
//  StringExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-10-10.
//

import Foundation

extension String {
    
    init(pushToken: Data) {
        let tokenParts = pushToken.map { data in String(format: "%02.2hhx", data) }
        self = tokenParts.joined()
    }
    
}
