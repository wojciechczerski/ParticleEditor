// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct RoundingFloatSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>

    init(value: Binding<CGFloat>, in range: ClosedRange<CGFloat>) {
        _value = value
        self.range = range
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
                binding.wrappedValue = $0.rounded()
            }
        )
    }
}
