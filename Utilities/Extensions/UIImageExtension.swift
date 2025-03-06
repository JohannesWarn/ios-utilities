//
//  UIImageExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-10-10.
//

import UIKit

extension UIImage {
    
    static func cachedImage(forURL url: URL) -> UIImage? {
        let cacheRequest = URLRequest(url: url, cachePolicy: .returnCacheDataDontLoad)
        let cachedResponse = URLCache.shared.cachedResponse(for: cacheRequest)
        if let data = cachedResponse?.data {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    static func load(fromURL url: URL) async throws -> UIImage {
        return try await ImageLoader.shared.load(fromURL: url)
    }
    
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    func resized(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        
        switch contentMode {
        case .contentFill:
            return resized(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resized(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resized(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    
    private func resized(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func getPixelColor(pos: CGPoint) -> UIColor {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func dominantColor() -> UIColor {
        guard let cgImage = self.cgImage else { return .white }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let bitmapData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var redTotal = 0
        var greenTotal = 0
        var blueTotal = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let pixelIndex = ((width * y) + x) * 4
                redTotal += Int(bitmapData[pixelIndex])
                greenTotal += Int(bitmapData[pixelIndex + 1])
                blueTotal += Int(bitmapData[pixelIndex + 2])
            }
        }
        
        let pixelCount = width * height
        let red = redTotal / pixelCount
        let green = greenTotal / pixelCount
        let blue = blueTotal / pixelCount
        
        bitmapData.deallocate()
        
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
}

fileprivate actor ImageLoader {
    enum ImageError: Error {
        case invalidImageData
    }
    
    private var ongoingTasks: [URL: Task<UIImage, Error>] = [:]
    
    static let shared = ImageLoader()
    
    func load(fromURL url: URL) async throws -> UIImage {
        if let existingTask = ongoingTasks[url] {
            return try await existingTask.value
        } else {
            let task = Task { () throws -> UIImage in
                let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                
                guard let image = UIImage(data: data) else {
                    throw ImageError.invalidImageData
                }
                
                return image
            }
            
            ongoingTasks[url] = task
            
            do {
                let image = try await task.value
                ongoingTasks.removeValue(forKey: url)
                return image
            } catch {
                ongoingTasks.removeValue(forKey: url)
                throw error
            }
        }
    }
}
