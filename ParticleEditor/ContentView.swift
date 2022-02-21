// Copyright © 2021 Wojciech Czerski. All rights reserved.

import Combine
import SwiftUI

class ParticleEmitter: ObservableObject {
    @Published var position: CGPoint = .zero
    @Published var size: CGSize = .zero
    @Published var birthrate: CGFloat = 0
    @Published var lifetime: CGFloat = 0
    @Published var velocity: CGFloat = 0
    @Published var velocityRange: CGFloat = 0
}

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

enum Property: String, CaseIterable, Identifiable {
    case position = "Position"
    case size = "Size"
    case birthrate = "Birthrate"
    case lifetime = "Lifetime"
    case velocity = "Velocity"

    var id: String { rawValue }
}

struct PropertyButtonStyle: ButtonStyle {
    let selected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(4)
            .border(Color.black)
            .foregroundColor(selected ? Color.white : Color.black)
            .background(selected ? Color.black : Color.clear)
    }
}

struct ContentView: View {
    @StateObject var particleEmitter: ParticleEmitter
    @State var editedProperty = Property.birthrate
    @State var emitterPositionBeforeDrag: CGPoint?
    @State var emitterSizeBeforeZoom: CGSize?

    init() {
        let emitter = ParticleEmitter()
        emitter.position = .init(x: 100, y: 100)
        emitter.size = .init(width: 200, height: 200)
        emitter.birthrate = 10
        emitter.lifetime = 3
        emitter.velocity = 50

        _particleEmitter = StateObject(wrappedValue: emitter)
    }

    var body: some View {
        VStack(alignment: .leading) {
            ParticleEmitterView(emitter: particleEmitter)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            var position = self.particleEmitter.position
                            if let initialPosition = emitterPositionBeforeDrag {
                                position = initialPosition
                            } else {
                                emitterPositionBeforeDrag = position
                            }
                            self.particleEmitter.position = CGPoint(x: position.x + value.translation.width,
                                                                    y: position.y + value.translation.height)
                        }
                        .onEnded { value in
                            var position = self.particleEmitter.position
                            if let initialPosition = emitterPositionBeforeDrag {
                                position = initialPosition
                            } else {
                                emitterPositionBeforeDrag = position
                            }
                            self.particleEmitter.position = CGPoint(x: position.x + value.translation.width,
                                                                    y: position.y + value.translation.height)

                            emitterPositionBeforeDrag = nil
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            var size = self.particleEmitter.size
                            if let initialSize = emitterSizeBeforeZoom {
                                size = initialSize
                            } else {
                                emitterSizeBeforeZoom = size
                            }
                            self.particleEmitter.size = CGSize(width: size.width * value,
                                                               height: size.height * value)
                        }
                        .onEnded { value in
                            var size = self.particleEmitter.size
                            if let initialSize = emitterSizeBeforeZoom {
                                size = initialSize
                            } else {
                                emitterSizeBeforeZoom = size
                            }
                            self.particleEmitter.size = CGSize(width: size.width * value,
                                                               height: size.height * value)
                            emitterSizeBeforeZoom = nil
                        }
                )
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(Property.allCases) { property in
                        Button(property.rawValue) {
                            editedProperty = property
                        }.buttonStyle(PropertyButtonStyle(selected: property == editedProperty))
                    }
                }
            }
            switch editedProperty {
            case .position:
                HStack {
                    Text("X")
                    CGFloatTextField(value: $particleEmitter.position.x)
                        .inputFieldStyle()
                    Text("Y")
                    CGFloatTextField(value: $particleEmitter.position.y)
                        .inputFieldStyle()
                }
            case .size:
                HStack {
                    Text("Width")
                    CGFloatTextField(value: $particleEmitter.size.width)
                        .inputFieldStyle()
                    Text("Height")
                    CGFloatTextField(value: $particleEmitter.size.height)
                        .inputFieldStyle()
                }
            case .birthrate:
                HStack {
                    Slider(value: $particleEmitter.birthrate, in: 0 ... 100)
                    CGFloatTextField(value: $particleEmitter.birthrate)
                        .inputFieldStyle()
                        .frame(width: 70)
                }
            case .lifetime:
                HStack {
                    Slider(value: $particleEmitter.lifetime, in: 0 ... 20)
                    CGFloatTextField(value: $particleEmitter.lifetime)
                        .inputFieldStyle()
                        .frame(width: 70)
                }
            case .velocity:
                VStack {
                    HStack {
                        Slider(value: $particleEmitter.velocity, in: -150 ... 150)
                        CGFloatTextField(value: $particleEmitter.velocity)
                            .inputFieldStyle()
                            .frame(width: 70)
                    }
                    HStack {
                        Slider(value: $particleEmitter.velocityRange, in: -100 ... 100)
                        CGFloatTextField(value: $particleEmitter.velocityRange)
                            .inputFieldStyle()
                            .frame(width: 70)
                    }
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button(action: {
                        let resign = #selector(UIResponder.resignFirstResponder)
                        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
