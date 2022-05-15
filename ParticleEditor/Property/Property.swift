// Copyright © 2022 Wojciech Czerski. All rights reserved.

import Foundation

enum Property: String, CaseIterable, Identifiable {
    case position = "Position"
    case size = "Size"
    case birthrate = "Birthrate"
    case lifetime = "Lifetime"
    case velocity = "Velocity"
    case color = "Color"

    var id: String { rawValue }
}
