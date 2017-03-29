import UIKit

internal struct RotationOptions: OptionSet {
    let rawValue: Int
    
    static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
    static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
}

public extension UIImage {
    
    // This outputs the image as an array of pixels
    public func pixelData() -> [[UInt8]]? {
        

        // Resize and rotate the image
        let resizedImage = self.resizeImage(newHeight: 50)
        let rotatedImage = resizedImage.rotated(by: Measurement(value: 90, unit: .degrees), options: RotationOptions.flipOnHorizontalAxis)!
        
        // Get the size of the image to be used in calculatations below
        let size = rotatedImage.size
        let width = size.width
        let height = size.height
        
        // Generate pixel array
        let dataSize = width * height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: &pixelData,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = rotatedImage.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        
        // Clean pixels to just keep black pixels
        let cleanedPixels = stride(from: 1, to: pixelData.count, by: 2).map {
            pixelData[$0]
        }
        
        // Separate pixels into rows (Array of arrays)
        let chunkSize = 2 * Int(width) // this was 4
        let chunks = stride(from: 0, to: cleanedPixels.count, by: chunkSize).map {
            Array(cleanedPixels[$0..<min($0 + chunkSize, cleanedPixels.count)])
        }
        
        

        
        return chunks

        
    }
    
    
    
    func resizeImage(newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    internal func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)
            
            let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
            let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
    
    
    
    
}


