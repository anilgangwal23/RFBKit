//
//  File.swift
//  
//
//  Created by Henrik Storch on 16.06.21.
//


import Foundation
import CoreGraphics


/**
 A class to proccess raw image data
 */
class ImageProcessor {
    
    /// Makes a image from a RGB32 bitmap.
    ///
    /// This means each pixel is represented by 32 bits, with 8 bits for each red, green, blue, and alpha
    /// - Parameters:
    ///   - data: Pixel data
    ///   - width: Width of the image
    ///   - height: Height of the image
    /// - Returns: The image
    static func imageFromARGB32Bitmap(data: NSData, width: Int, height: Int) -> CGImage {
        let bitsPerComponent: Int = 8
        let bitsPerPixel: Int = 32
        
        let providerRef = CGDataProvider(data: data)
        let rgb = CGColorSpaceCreateDeviceRGB()
        
        // Server pixels are B,G,R,X in memory (little-endian 32-bit). CGImage rejects
        // alpha `none` at 32 bpp, so use `noneSkipFirst` with little-endian byte order.
        let bitmapinfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
            .union(.byteOrder32Little)
        
        let cgim: CGImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * 4,
            space: rgb,
            bitmapInfo: bitmapinfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent)!
        
        return cgim
    }
}
