// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct CGFloatTextField: View {
    @Binding var value: CGFloat
    let formatter = createNumberFormatter()

    var body: some View {
        let numberProxy = Binding<String>(
            get: {
                formatter.string(from: NSNumber(value: Double(value))) ?? ""
            },
            set: {
                if let value = formatter.number(from: $0) {
                    self.value = CGFloat(truncating: value)
                }
            }
        )
        TextField("", text: numberProxy)
            .keyboardType(.decimalPad)
    }

    private static func createNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
