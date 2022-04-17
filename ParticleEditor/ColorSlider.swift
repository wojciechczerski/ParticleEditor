// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct ColorSlider<T: BinaryFloatingPoint>: UIViewRepresentable {
    @Binding var value: T
    @Binding var color: Color

    func makeUIView(context _: Context) -> CustomSlider<T> {
        let slider = CustomSlider<T>()
        slider.valueBinding = _value
        slider.maximumValue = 0.99
        slider.minimumTrackTintColor = #colorLiteral(red: 0.796662415, green: 0.796662415, blue: 0.796662415, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.796662415, green: 0.796662415, blue: 0.796662415, alpha: 1)
        return slider
    }

    func updateUIView(_ slider: CustomSlider<T>, context _: Context) {
        slider.valueBinding = _value
        slider.value = Float(value)
        slider.thumbTintColor = UIColor(color)
    }
}
