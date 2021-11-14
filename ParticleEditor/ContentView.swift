// Copyright © 2021 Wojciech Czerski. All rights reserved.

import SwiftUI
import Combine

class ParticleEmitter: ObservableObject {
    @Published var position: CGPoint = .zero
    @Published var size: CGSize = .zero
    @Published var birthrate: CGFloat = 0
    @Published var lifetime: CGFloat = 0
}

struct CGFloatTextField: View {
    @Binding var value: CGFloat

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        TextField("", value: $value, formatter: numberFormatter)
    }
}

class CAEmitterLayerView: UIView {
    let emitterLayer = CAEmitterLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        emitterLayer.anchorPoint = .zero
        emitterLayer.bounds = layer.bounds
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: frame.size.width, height: 1.0)
        emitterLayer.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        layer.addSublayer(emitterLayer)
    }
}

struct ParticleEmitterView: UIViewRepresentable {
    @ObservedObject var emitter: ParticleEmitter
    
    func updateUIView(_ emitterView: CAEmitterLayerView, context: Context) {
        emitterView.emitterLayer.position = emitter.position
        emitterView.emitterLayer.bounds.size = emitter.size
        emitterView.emitterLayer.emitterSize = .init(width: emitter.size.width, height: 0)
        emitterView.emitterLayer.emitterPosition = CGPoint(x: emitter.size.width / 2.0, y: 0)
        emitterView.emitterLayer.emitterCells = [emitterCell()]
    }
    
    func makeUIView(context: Context) -> CAEmitterLayerView {
        let view = CAEmitterLayerView()
        view.emitterLayer.backgroundColor = UIColor.blue.cgColor
        return view
    }
    
    private func emitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = Float(emitter.birthrate)
        cell.lifetime = Float(emitter.lifetime)
        cell.velocity = CGFloat(cell.birthRate * cell.lifetime)
        cell.velocityRange = cell.velocity / 2
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spinRange = .pi * 6
        cell.scaleRange = 0.25
        cell.scale = 1.0 - cell.scaleRange
        cell.contents = UIImage(named: "Particle")?.cgImage
        return cell
    }
}

struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .border(Color.black, width: 1)
    }
}

extension View {
    func inputFieldStyle() -> some View {
        modifier(InputFieldStyle())
    }
}

struct ContentView: View {
    @StateObject var particleEmitter: ParticleEmitter
    
    init() {
        let emitter = ParticleEmitter()
        emitter.position = .init(x: 0, y: 100)
        emitter.size = .init(width: 300, height: 400)
        emitter.birthrate = 50
        emitter.lifetime = 3
        
        _particleEmitter = StateObject(wrappedValue: emitter)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Position")
                CGFloatTextField(value: $particleEmitter.position.x)
                    .inputFieldStyle()
                Slider(value: $particleEmitter.position.x, in: -300...300)
                CGFloatTextField(value: $particleEmitter.position.y)
                    .inputFieldStyle()
            }
            HStack {
                Text("Size")
                CGFloatTextField(value: $particleEmitter.size.width)
                    .inputFieldStyle()
                CGFloatTextField(value: $particleEmitter.size.height)
                    .inputFieldStyle()
            }
            HStack {
                Text("Birthrate")
                CGFloatTextField(value: $particleEmitter.birthrate)
                    .inputFieldStyle()
            }
            HStack {
                Text("Lifetime")
                CGFloatTextField(value: $particleEmitter.lifetime)
                    .inputFieldStyle()
            }
            ParticleEmitterView(emitter: particleEmitter)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
