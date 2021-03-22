//
//  UIImage+.swift
//  Mymanu Play
//
//  Created by Duy Nguyen on 1/8/21.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

extension UIImage {
    //Allows construction of uiimage with a color
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    var localURL: URL? {
        let id = UUID().uuidString
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationPath = documentsPath.appendingPathComponent("\(id).jpeg")
        try? self.jpegData(compressionQuality: 1.0)?.write(to: destinationPath)
        return destinationPath
    }
    
    func pixelData() -> [UInt8]? {
            let size = self.size
            let dataSize = size.width * size.height * 4
            var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: &pixelData,
                                    width: Int(size.width),
                                    height: Int(size.height),
                                    bitsPerComponent: 8,
                                    bytesPerRow: 4 * Int(size.width),
                                    space: colorSpace,
                                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
            guard let cgImage = self.cgImage else { return nil }
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            return pixelData
        }
}


