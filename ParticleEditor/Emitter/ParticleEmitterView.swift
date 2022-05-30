// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct ParticleEmitterView: UIViewRepresentable {
    @ObservedObject var emitter: ParticleEmitter

    func updateUIView(_ emitterView: CAEmitterLayerView, context _: Context) {
        emitterView.emitterLayer.frame = emitterView.layer.frame
        emitterView.emitterLayer.emitterSize = emitter.size
        emitterView.emitterLayer.emitterPosition = emitter.position
        emitterView.emitterLayer.emitterCells = [emitterCell()]
        emitterView.updateEmitterFrame()
    }

    func makeUIView(context _: Context) -> CAEmitterLayerView {
        let view = CAEmitterLayerView()
        view.emitterLayer.backgroundColor = UIColor.black.cgColor
        return view
    }

    private func emitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.alphaRange = Float(emitter.alphaRange)
        cell.alphaSpeed = Float(emitter.alphaSpeed)
        cell.birthRate = Float(emitter.birthrate)
        cell.lifetime = Float(emitter.lifetime)
        cell.velocity = emitter.velocity
        cell.velocityRange = emitter.velocityRange
        cell.color = emitter.color.cgColor
        cell.emissionLongitude = emitter.emissionLongitude
        cell.emissionRange = emitter.emissionRange
        cell.scaleRange = emitter.scaleRange
        cell.scale = emitter.scale
        cell.scaleSpeed = emitter.scaleSpeed
        cell.contents = UIImage(named: "Particle")?.cgImage
        return cell
    }
}
