//
//  UIViewExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-10-06.
//

import UIKit

extension UIView {
    func renderToImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return image
            }
        }
        
        return UIImage()
    }
}
