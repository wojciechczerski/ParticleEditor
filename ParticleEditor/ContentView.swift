// Copyright © 2021 Wojciech Czerski. All rights reserved.

import SwiftUI
import Combine

class ParticleEmitter: ObservableObject {
    @Published var position: CGPoint = .zero
    @Published var size: CGSize = .zero
    @Published var birthrate: CGFloat = 0
    
    init(position: CGPoint, size: CGSize, birthrate: CGFloat) {
        self.position = position
        self.size = size
        self.birthrate = birthrate
    }
}

class MutableValue<T> {
    var value: T
    
    init(value: T) {
        self.value = value
    }
}

struct CGFloatTextField: View {
    @Binding var floatValue: CGFloat

    @State private var input: String
    private let numberFormatter = NumberFormatter()
    private let currentNumber: MutableValue<NSNumber> = MutableValue(value: NSDecimalNumber.zero)
    
    init(value: Binding<CGFloat>) {
        _floatValue = value

        if let initialInput = numberFormatter.string(from: NSDecimalNumber(floatLiteral: Double(value.wrappedValue))) {
            _input = State(initialValue: initialInput)
        } else {
            _input = State(initialValue: "0")
        }
    }
    
    var body: some View {
        TextField("", text: $input)
            .onChange(of: input, perform: handleInputChange)
    }
    
    private func handleInputChange(_ input: String) {
        if let newNumber = numberFormatter.number(from: input), newNumber != currentNumber.value {
            currentNumber.value = newNumber
            floatValue = CGFloat(truncating: newNumber)
        }
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
        cell.lifetime = 10.0
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

struct ContentView: View {
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
        return formatter
    }()

    @StateObject var particleEmitter = ParticleEmitter(position: .init(x: 0, y: 100),
                                                       size: .init(width: 300, height: 400),
                                                       birthrate: 50)

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Position")
                CGFloatTextField(value: $particleEmitter.position.x)
                    .padding(8)
                    .border(Color.black, width: 1)
                CGFloatTextField(value: $particleEmitter.position.y)
                    .padding(8)
                    .border(Color.black, width: 1)
            }
            HStack {
                Text("Size")
                CGFloatTextField(value: $particleEmitter.size.width)
                    .padding(8)
                    .border(Color.black, width: 1)
                CGFloatTextField(value: $particleEmitter.size.height)
                    .padding(8)
                    .border(Color.black, width: 1)
            }
            HStack {
                Text("Birthrate")
                CGFloatTextField(value: $particleEmitter.birthrate)
                    .padding(8)
                    .border(Color.black, width: 1)
                
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
