// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

public enum RoundingPrecision {
    case ones
    case tenths
    case hundredths
}

struct RoundingFloatSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let precision: RoundingPrecision

    init(value: Binding<CGFloat>,
         in range: ClosedRange<CGFloat>,
         precision: RoundingPrecision = .ones) {
        _value = value
        self.range = range
        self.precision = precision
    }

    var body: some View {
        Slider(value: roundingBinding(binding: $value), in: range)
    }

    private func roundingBinding(binding: Binding<CGFloat>) -> Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                binding.wrappedValue
            },
            set: {
                binding.wrappedValue = preciseRound(value: $0, precision: precision)
            }
        )
    }

    private func preciseRound(value: Double, precision: RoundingPrecision = .ones) -> Double {
        switch precision {
        case .ones:
            return round(value)
        case .tenths:
            return round(value * 10) / 10.0
        case .hundredths:
            return round(value * 100) / 100.0
        }
    }
}
