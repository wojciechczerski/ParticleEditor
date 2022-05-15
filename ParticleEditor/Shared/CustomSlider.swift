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

    func setThumb(color: UIColor) {
        let size = CGSize(width: 32, height: 32)
        setThumbImage(.ellipse(size: size, lineWidth: 2, strokeColor: .gray, fillColor: color),
                      for: .normal)
    }

    private func commonInit() {
        setThumb(color: .white)
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    @objc private func valueChanged() {
        valueBinding?.wrappedValue = T(value)
    }
}
