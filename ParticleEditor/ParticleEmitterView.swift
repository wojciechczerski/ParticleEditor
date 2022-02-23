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
        view.emitterLayer.backgroundColor = UIColor.blue.cgColor
        return view
    }

    private func emitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = Float(emitter.birthrate)
        cell.lifetime = Float(emitter.lifetime)
        cell.velocity = emitter.velocity
        cell.velocityRange = emitter.velocityRange
//        cell.emissionLongitude = .pi
//        cell.emissionRange = .pi / 4
//        cell.spinRange = .pi * 6
        cell.scaleRange = 0.25
        cell.scale = 1.0 - cell.scaleRange
        cell.contents = UIImage(named: "Particle")?.cgImage
        return cell
    }
}
