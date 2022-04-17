// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

class CustomSlider<T: BinaryFloatingPoint>: UISlider {
    var valueBinding: Binding<T>?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    @objc private func valueChanged() {
        valueBinding?.wrappedValue = T(value)
    }
}
