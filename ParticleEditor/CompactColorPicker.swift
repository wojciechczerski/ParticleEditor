// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CompactPickerView: View {
    enum ColorAttribute: Int, CaseIterable {
        case hue
        case saturation
        case brightness
        case alpha
    }

    @Binding var color: Color
    @State private var selectedColorAttribute = ColorAttribute.hue
    @State private var hue = CGFloat.zero
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    @State private var alpha: CGFloat = 1.0

    init(color: Binding<Color>) {
        _color = color
        hue = color.wrappedValue.hue
        saturation = color.wrappedValue.saturation
        brightness = color.wrappedValue.brightness
        alpha = color.wrappedValue.alpha
    }

    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $selectedColorAttribute) {
                    Text("Hue").tag(ColorAttribute.hue)
                    Text("Saturation").tag(ColorAttribute.saturation)
                    Text("Brightness").tag(ColorAttribute.brightness)
                    Text("Alpha").tag(ColorAttribute.alpha)
                }.pickerStyle(.segmented)
                    .controlSize(.regular)
                ColorPicker("", selection: colorPickerBindingProxy())
                    .fixedSize()
            }
            switch selectedColorAttribute {
            case .hue:
                let hues = Array(stride(from: 0.0, to: 1.0, by: 0.05))
                let modifiedColors = hues.map {
                    Color(hue: $0, saturation: saturation, brightness: brightness, opacity: alpha)
                }
                ZStack {
                    CheckerPattern()
                    LinearGradient(colors: modifiedColors, startPoint: .leading, endPoint: .trailing)
                }
                .frame(height: 40)
                ColorSlider(value: bindingProxy($hue), color: $color)
            case .saturation:
                let colors = [
                    Color(hue: hue, saturation: 0, brightness: brightness, opacity: alpha),
                    Color(hue: hue, saturation: 1, brightness: brightness, opacity: alpha)
                ]
                ZStack {
                    CheckerPattern()
                    LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                }
                .frame(height: 40)
                ColorSlider(value: bindingProxy($saturation), color: $color)
            case .brightness:
                let colors = [
                    Color(hue: hue, saturation: saturation, brightness: 0, opacity: alpha),
                    Color(hue: hue, saturation: saturation, brightness: 1, opacity: alpha)
                ]
                ZStack {
                    CheckerPattern()
                    LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                }
                .frame(height: 40)
                ColorSlider(value: bindingProxy($brightness), color: $color)
            case .alpha:
                let colors = [
                    Color(hue: hue, saturation: saturation, brightness: brightness, opacity: 0),
                    Color(hue: hue, saturation: saturation, brightness: brightness, opacity: 1)
                ]
                ZStack {
                    CheckerPattern()
                    LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                }
                .frame(height: 40)
                ColorSlider(value: bindingProxy($alpha), color: $color)
            }
        }
    }

    private func bindingProxy(_ binding: Binding<CGFloat>) -> Binding<CGFloat> {
        .init(get: {
            binding.wrappedValue
        }, set: {
            binding.wrappedValue = $0
            updateColor()
        })
    }

    private func colorPickerBindingProxy() -> Binding<Color> {
        .init(get: {
            color
        }, set: {
            color = $0
            hue = $0.hue
            saturation = $0.saturation
            brightness = $0.brightness
            alpha = $0.alpha
        })
    }

    private func updateColor() {
        color = Color(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
}

struct CompactPickerView_Previews: PreviewProvider {
    @State static var color = Color.red

    static var previews: some View {
        CompactPickerView(color: $color)
            .previewLayout(.fixed(width: 320, height: 200))
    }
}
