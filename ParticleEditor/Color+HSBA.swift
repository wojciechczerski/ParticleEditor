// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct HSBA {
    let hue: CGFloat
    let saturation: CGFloat
    let brightness: CGFloat
    let alpha: CGFloat
}

extension Color {
    var hsba: HSBA {
        var hue = CGFloat.zero
        var saturation = CGFloat.zero
        var brightness = CGFloat.zero
        var alpha = CGFloat.zero
        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return HSBA(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    var hue: CGFloat {
        hsba.hue
    }

    var saturation: CGFloat {
        hsba.saturation
    }

    var brightness: CGFloat {
        hsba.brightness
    }

    var alpha: CGFloat {
        hsba.alpha
    }

    func with(hue: CGFloat? = nil,
              saturation: CGFloat? = nil,
              brightness: CGFloat? = nil,
              alpha: CGFloat? = nil) -> Color {
        return Color(UIColor(hue: hue ?? self.hue,
                             saturation: saturation ?? self.saturation,
                             brightness: brightness ?? self.brightness,
                             alpha: alpha ?? self.alpha))
    }
}
