// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

class ParticleEmitter: ObservableObject {
    @Published var position: CGPoint = .zero
    @Published var size: CGSize = .zero
    @Published var birthrate: CGFloat = 0
    @Published var lifetime: CGFloat = 0
    @Published var velocity: CGFloat = 0
    @Published var velocityRange: CGFloat = 0
    @Published var color: Color = .white
    @Published var emissionRange = CGFloat.zero
    @Published var emissionLongitude = CGFloat.zero
    @Published var scale: CGFloat = 1
    @Published var scaleRange: CGFloat = 0
    @Published var scaleSpeed: CGFloat = 0
    @Published var alphaRange: CGFloat = 0
    @Published var alphaSpeed: CGFloat = 0
}
