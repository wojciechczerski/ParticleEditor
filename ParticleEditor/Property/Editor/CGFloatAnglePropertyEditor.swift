// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CGFloatAnglePropertyEditor: View {
    @Binding var radians: CGFloat
    let range: ClosedRange<CGFloat>

    var body: some View {
        HStack {
            let bindingProxy: Binding<CGFloat> = .init(
                get: {
                    radians.degrees
                }, set: { degrees in
                    radians = degrees.radians
                }
            )
            RoundingFloatSlider(value: bindingProxy, in: range)
            CGFloatTextField(value: bindingProxy)
                .frame(width: 70)
        }
    }
}
