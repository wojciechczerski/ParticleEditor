// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CheckerPattern: View {
    @State var checkSize: CGFloat = 10
    @State var lightColor = Color(white: 0.99)
    @State var darkColor = Color(white: 0.88)

    var body: some View {
        Canvas { context, size in
            let numCols = Int((size.width / checkSize).rounded(.up))
            let numRows = Int((size.height / checkSize).rounded(.up))
            var startFromZero = true

            context.fill(.init(.init(origin: .zero, size: size)), with: .color(lightColor))

            for row in 0 ..< numRows {
                for col in stride(from: startFromZero ? 0 : 1, to: numCols, by: 2) {
                    let rect = CGRect(x: CGFloat(col) * checkSize,
                                      y: CGFloat(row) * checkSize,
                                      width: checkSize,
                                      height: checkSize)
                    context.fill(.init(rect), with: .color(darkColor))
                }
                startFromZero.toggle()
            }
            context.fill(.init(), with: .color(.gray))
        }
    }
}
