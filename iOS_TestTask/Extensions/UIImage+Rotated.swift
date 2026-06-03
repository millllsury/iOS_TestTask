//
//  UIImage+Rotated.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 24/05/2026.
//

import UIKit

extension UIImage {
    func rotated(by radians: CGFloat) -> UIImage {
        let newSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            context.cgContext.translateBy(x: newSize.width / 2, y: newSize.height / 2)
            context.cgContext.rotate(by: radians)
            draw(in: CGRect(
                x: -size.width / 2,
                y: -size.height / 2,
                width: size.width,
                height: size.height
            ))
        }
    }
}
