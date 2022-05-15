// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CGFloatAnglePropertyEditor: View {
    @Binding var radians: CGFloat

    var body: some View {
        HStack {
            let bindingProxy: Binding<CGFloat> = .init(
                get: {
                    radians * 180 / .pi
                }, set: { degrees in
                    radians = degrees * .pi / 180
                }
            )
            RoundingFloatSlider(value: bindingProxy, in: 0 ... 360)
            CGFloatTextField(value: bindingProxy)
                .frame(width: 70)
        }
    }
}
