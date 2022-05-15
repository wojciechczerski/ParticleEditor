// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CGSizePropertyEditor: View {
    @Binding var size: CGSize

    var body: some View {
        HStack {
            Text("Width")
            CGFloatTextField(value: $size.width)
            Text("Height")
            CGFloatTextField(value: $size.height)
        }
    }
}
