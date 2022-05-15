// Copyright © 2022 Wojciech Czerski. All rights reserved.

import UIKit

extension UIImage {
    static func ellipse(size: CGSize,
                        lineWidth: CGFloat,
                        strokeColor: UIColor,
                        fillColor: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            let rect = CGRect(origin: .zero, size: size)
            fillColor.setFill()
            rendererContext.cgContext.fillEllipse(in: rect)
            strokeColor.setStroke()
            rendererContext.cgContext.setLineWidth(lineWidth)
            rendererContext.cgContext.strokeEllipse(in: rect.insetBy(dx: lineWidth / 2,
                                                                     dy: lineWidth / 2))
        }
    }
}
