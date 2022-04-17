// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CompactPickerView: View {
    enum ColorAttribute: Int, CaseIterable {
        case hue
        case saturation
        case brightness
        case alpha
    }

    @Binding var selectedColor: Color
    @State private var selectedColorAttribute = ColorAttribute.hue

    var body: some View {
        VStack {
            Picker("", selection: $selectedColorAttribute) {
                Text("Hue").tag(ColorAttribute.hue)
                Text("Saturation").tag(ColorAttribute.saturation)
                Text("Brightness").tag(ColorAttribute.brightness)
                Text("Alpha").tag(ColorAttribute.alpha)
            }.pickerStyle(.segmented)
            switch selectedColorAttribute {
            case .hue:
                let bindingProxy = Binding<CGFloat>(
                    get: {
                        selectedColor.hue
                    }, set: {
                        selectedColor = selectedColor.with(hue: $0)
                    }
                )
                let hues = Array(stride(from: 0.0, to: 1.0, by: 0.05))
                let modifiedColors = hues.map {
                    selectedColor.with(hue: $0)
                }
                LinearGradient(colors: modifiedColors, startPoint: .leading, endPoint: .trailing)
                    .frame(height: 40)
                ColorSlider(value: bindingProxy, color: $selectedColor)
            case .saturation:
                let bindingProxy = Binding<CGFloat>(
                    get: {
                        selectedColor.saturation
                    }, set: {
                        selectedColor = selectedColor.with(saturation: $0)
                    }
                )
                let colors = [selectedColor.with(saturation: 0), selectedColor.with(saturation: 1)]
                LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                    .frame(height: 40)
                ColorSlider(value: bindingProxy, color: $selectedColor)
            case .brightness:
                let bindingProxy = Binding<CGFloat>(
                    get: {
                        selectedColor.brightness
                    }, set: {
                        selectedColor = selectedColor.with(brightness: $0)
                    }
                )
                let colors = [selectedColor.with(brightness: 0), selectedColor.with(brightness: 1)]
                LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                    .frame(height: 40)
                ColorSlider(value: bindingProxy, color: $selectedColor)
            case .alpha:
                let bindingProxy = Binding<CGFloat>(
                    get: {
                        selectedColor.alpha
                    }, set: {
                        selectedColor = selectedColor.with(alpha: $0)
                    }
                )
                let colors = [selectedColor.with(alpha: 0), selectedColor.with(alpha: 1)]
                LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                    .frame(height: 40)
                ColorSlider(value: bindingProxy, color: $selectedColor)
            }
        }
    }
}

struct CompactPickerView_Previews: PreviewProvider {
    @State static var color = Color.red

    static var previews: some View {
        CompactPickerView(selectedColor: $color)
            .previewLayout(.fixed(width: 320, height: 200))
    }
}
