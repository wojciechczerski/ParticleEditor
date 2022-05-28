// Copyright © 2022 Wojciech Czerski. All rights reserved.

import CoreGraphics

extension CGFloat {
    var radians: CGFloat {
        self * .pi / 180
    }

    var degrees: CGFloat {
        self * 180 / .pi
    }
}
