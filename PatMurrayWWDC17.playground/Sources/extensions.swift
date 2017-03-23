import UIKit

public extension UIImage {
    
    // This outputs the image as an array of pixels
    public func pixelData() -> [UInt8]? {
        
        var pixelValues: [UInt8]?

        // Resize and rotate the image
        // NOTE: For simplicity's sake, all numbers/sizes are hardcoded at this time
        let newHeight = 122
        UIGraphicsBeginImageContext(CGSize(width: newHeight, height: newHeight))
        
        self.draw(in: CGRect(x: 61, y: 61,width: newHeight, height: newHeight))

        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        if let imageRef = resizedImage?.cgImage {
            let width = imageRef.width
            let height = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            print(bitsPerComponent)
            let bytesPerRow = imageRef.bytesPerRow
            print(bytesPerRow)
            let totalBytes = height * bytesPerRow
            print(totalBytes)
            
            let colorSpace = CGColorSpaceCreateDeviceGray()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: 1)
            
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
            pixelValues = intensities
            
            var intensityArray: [[Int]] = Array(repeating: Array(repeating: 0, count: width), count: height)
            
            for index1 in 0...height-1{  //make sure height-1 is here always
                for index2 in 0...width-1{  //(width-1) has to goes here because the last place in the array is the size-1
                    let colorIndex = (index1 * width + index2)
                    let value = pixelValues?[colorIndex]

                    
                    intensityArray[index1][index2] = Int(value!)
                }
            }
            
            print(intensityArray)
            
        }
        
        
        return pixelValues
        
    }
    
    
    
    
}


