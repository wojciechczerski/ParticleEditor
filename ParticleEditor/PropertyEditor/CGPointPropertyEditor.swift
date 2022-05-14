// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CGPointPropertyEditor: View {
    @Binding var point: CGPoint

    var body: some View {
        HStack {
            Text("X")
            CGFloatTextField(value: $point.x)
            Text("Y")
            CGFloatTextField(value: $point.y)
        }
    }
}
