// Copyright © 2021 Wojciech Czerski. All rights reserved.

import SwiftUI
import Combine

class ParticleEmitter: ObservableObject {
    var position: CGPoint = .zero
    var size: CGSize = .zero
    @Published var birthrate: CGFloat = 0
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
    @Binding var position: CGPoint
    @Binding var size: CGSize
    @Binding var birthrate: CGFloat
    
    func updateUIView(_ emitterView: CAEmitterLayerView, context: Context) {
        emitterView.emitterLayer.position = position
        emitterView.emitterLayer.bounds.size = size
        emitterView.emitterLayer.emitterSize = .init(width: size.width, height: 0)
        emitterView.emitterLayer.emitterPosition = CGPoint(x: size.width / 2.0, y: 0)
        emitterView.emitterLayer.emitterCells = [emitterCell()]
    }
    
    func makeUIView(context: Context) -> CAEmitterLayerView {
        let view = CAEmitterLayerView()
        view.emitterLayer.backgroundColor = UIColor.blue.cgColor
        return view
    }
    
    private func emitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = Float(birthrate)
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

class CGSizeInput: ObservableObject {
    var width: String { didSet { inputDidChange() }}
    var height: String { didSet { inputDidChange() }}
    @Published var size: CGSize = .zero
    
    private let numberFormatter = NumberFormatter()
    private var currentWidth: NSNumber = NSDecimalNumber.zero
    private var currentHeight: NSNumber = NSDecimalNumber.zero
    
    init(width: CGFloat, height: CGFloat) {
        self.width = "\(width)"
        self.height = "\(height)"
        self.size = .init(width: width, height: height)
    }
    
    private func inputDidChange() {
        if let newWidth = numberFormatter.number(from: width), newWidth != currentWidth {
            size.width = CGFloat(truncating: newWidth)
            currentWidth = newWidth
        }
        
        if let newHeight = numberFormatter.number(from: height), newHeight != currentHeight {
            size.height = CGFloat(truncating: newHeight)
            currentHeight = newHeight
        }
    }
}

class CGPointInput: ObservableObject {
    var x: String { didSet { inputDidChange() }}
    var y: String { didSet { inputDidChange() }}
    @Published var point: CGPoint = .zero
    
    init(x: CGFloat, y: CGFloat) {
        self.x = "\(x)"
        self.y = "\(y)"
        self.point = .init(x: x, y: y)
    }
    
    private let numberFormatter = NumberFormatter()
    private var oldNumberX: NSNumber = NSDecimalNumber.zero
    
    private func inputDidChange() {
        if let numberX = numberFormatter.number(from: x), numberX != oldNumberX {
            point.x = CGFloat(truncating: numberX)
            oldNumberX = numberX
        }
        
        if let numberY = numberFormatter.number(from: y) {
            point.y = CGFloat(truncating: numberY)
        }
    }
}

class CGFloatInput: ObservableObject {
    var input: String { didSet { inputDidChange() }}
    @Published var floatValue: CGFloat = .zero
    
    private let numberFormatter = NumberFormatter()
    
    init(value: CGFloat) {
        input = "\(value)"
        floatValue = value
    }
    
    private func inputDidChange() {
        if let number = numberFormatter.number(from: input) {
            floatValue = CGFloat(truncating: number)
        }
    }
}

struct ContentView: View {
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
        return formatter
    }()

    @StateObject var particleEmitter = ParticleEmitter()
    @StateObject var pointInput = CGPointInput(x: 0, y: 100)
    @StateObject var sizeInput = CGSizeInput(width: 300, height: 400)
    @StateObject var birthrate = CGFloatInput(value: 50)
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Position")
                TextField("0.00", text: $pointInput.x)
                    .padding(8)
                    .border(Color.black, width: 1)
                TextField("0.00", text: $pointInput.y)
                    .padding(8)
                    .border(Color.black, width: 1)
            }
            HStack {
                Text("Size")
                TextField("0.00", text: $sizeInput.width)
                    .padding(8)
                    .border(Color.black, width: 1)
                TextField("0.00", text: $sizeInput.height)
                    .padding(8)
                    .border(Color.black, width: 1)
            }
            HStack {
                Text("Birthrate")
                TextField("0.00", text: $birthrate.input)
                    .padding(8)
                    .border(Color.black, width: 1)
                
            }
            HStack {
                Text("Particle Emitter (birth rate): \(particleEmitter.birthrate)")
            }
            ParticleEmitterView(position: $pointInput.point, size: $sizeInput.size, birthrate: $birthrate.floatValue)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
