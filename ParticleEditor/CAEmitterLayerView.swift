// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

class CAEmitterLayerView: UIView {
    lazy var emitterLayer = createEmitterLayer()
    lazy var emitterFrameLayer = createEmitterFrameLayer()

    var emitterFramePath: CGPath {
        let position = emitterLayer.emitterPosition
        let size = emitterLayer.emitterSize
        let origin = CGPoint(x: position.x - size.width / 2, y: position.y - size.height / 2)
        return CGPath(rect: .init(origin: origin, size: size), transform: nil)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        withDisabledAnimations {
            emitterLayer.frame = layer.frame
            emitterFrameLayer.frame = layer.frame
            updateEmitterFrame()
        }
    }

    func updateEmitterFrame() {
        emitterFrameLayer.path = emitterFramePath
    }

    private func createEmitterLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.anchorPoint = .zero
        emitterLayer.emitterShape = .rectangle
        layer.addSublayer(emitterLayer)
        layer.masksToBounds = true
        return emitterLayer
    }

    private func createEmitterFrameLayer() -> CAShapeLayer {
        let frameLayer = CAShapeLayer()
        frameLayer.anchorPoint = .zero
        frameLayer.path = emitterFramePath
        frameLayer.borderWidth = 1
        frameLayer.strokeColor = UIColor.red.cgColor
        frameLayer.fillColor = nil
        layer.addSublayer(frameLayer)
        return frameLayer
    }

    private func withDisabledAnimations(run block: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.commit()
    }
}
