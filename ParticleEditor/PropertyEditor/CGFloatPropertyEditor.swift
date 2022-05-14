// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CGFloatPropertyEditor: View {
    @Binding var value: CGFloat
    var range: ClosedRange<CGFloat> = 0 ... 1

    var body: some View {
        HStack {
            RoundingFloatSlider(value: $value, in: range)
            CGFloatTextField(value: $value)
                .frame(width: 70)
        }
    }
}
