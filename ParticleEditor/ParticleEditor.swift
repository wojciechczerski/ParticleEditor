// Copyright © 2021 Wojciech Czerski. All rights reserved.

import Combine
import SwiftUI

struct ParticleEditor: View {
    @StateObject var particleEmitter: ParticleEmitter
    @State var editedProperty: EmitterProperty
    @State var emitterPositionBeforeDrag: CGPoint?
    @State var emitterSizeBeforeZoom: CGSize?

    let properties: [EmitterProperty]

    init() {
        let emitter = ParticleEmitter()
        emitter.position = .init(x: 100, y: 100)
        emitter.size = .init(width: 200, height: 200)
        emitter.birthrate = 10
        emitter.lifetime = 3
        emitter.velocity = 50

        _particleEmitter = StateObject(wrappedValue: emitter)

        let positionProperty = CGPointEmitterProperty(info: .position,
                                                      property: emitter.property(\.position))

        properties = Self.createProperties(emitter: emitter, firstProperty: positionProperty)

        _editedProperty = State(wrappedValue: positionProperty)
    }

    static func createProperties(emitter: ParticleEmitter,
                                 firstProperty: EmitterProperty) -> [EmitterProperty] {
        [
            firstProperty,
            CGSizeEmitterProperty(info: .size, property: emitter.property(\.size)),
            CGFloatEmitterProperty(info: .birthrate,
                                   property: emitter.property(\.birthrate),
                                   range: 0 ... 100),
            CGFloatEmitterProperty(info: .lifetime,
                                   property: emitter.property(\.lifetime),
                                   range: 0 ... 20),
            CGFloatEmitterProperty(info: .velocity,
                                   property: emitter.property(\.velocity),
                                   range: -150 ... 150),
            CGFloatEmitterProperty(info: .velocityRange,
                                   property: emitter.property(\.velocityRange),
                                   range: -100 ... 100),
            ColorEmitterProperty(info: .color,
                                 property: emitter.property(\.color)),
            CGFloatAngleEmitterProperty(info: .emissionLongitude,
                                        property: emitter.property(\.emissionLongitude),
                                        range: 0 ... 360),
            CGFloatAngleEmitterProperty(info: .emissionRange,
                                        property: emitter.property(\.emissionRange),
                                        range: 0 ... 180),
            CGFloatEmitterProperty(info: .scale,
                                   property: emitter.property(\.scale),
                                   range: -5 ... 5, roundingPrecision: .tenths),
            CGFloatEmitterProperty(info: .scaleRange,
                                   property: emitter.property(\.scaleRange),
                                   range: -5 ... 5, roundingPrecision: .tenths),
            CGFloatEmitterProperty(info: .scaleSpeed,
                                   property: emitter.property(\.scaleSpeed),
                                   range: -5 ... 5, roundingPrecision: .tenths)
        ]
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ParticleEmitterView(emitter: particleEmitter)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.updateEmitterPosition(drag: value.translation)
                            }
                            .onEnded { value in
                                self.updateEmitterPosition(drag: value.translation)
                                emitterPositionBeforeDrag = nil
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                self.updateEmitterSize(scale: value)
                            }
                            .onEnded { value in
                                self.updateEmitterSize(scale: value)
                                emitterSizeBeforeZoom = nil
                            }
                    )
                NavigationLink(destination: PropertyList(emitter: particleEmitter,
                                                         properties: properties,
                                                         editedProperty: $editedProperty)) {
                    Text(editedProperty.info.name)
                }
                editedProperty.editorView
            }
            .textFieldStyle(.roundedBorder)
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(editedProperty.info.name)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func updateEmitterPosition(drag translation: CGSize) {
        var newPosition = particleEmitter.position
        if let initialPosition = emitterPositionBeforeDrag {
            newPosition = initialPosition
        } else {
            emitterPositionBeforeDrag = newPosition
        }
        particleEmitter.position = CGPoint(x: newPosition.x + translation.width,
                                           y: newPosition.y + translation.height)
    }

    private func updateEmitterSize(scale: CGFloat) {
        var newSize = particleEmitter.size
        if let initialSize = emitterSizeBeforeZoom {
            newSize = initialSize
        } else {
            emitterSizeBeforeZoom = newSize
        }
        particleEmitter.size = CGSize(width: newSize.width * scale,
                                      height: newSize.height * scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ParticleEditor()
    }
}
