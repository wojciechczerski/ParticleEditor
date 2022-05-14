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
    @Published var color: Color = .white
}

struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.roundedBorder)
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
    case color = "Color"

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

struct PropertyList: View {
    @Binding var editedProperty: Property
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        List(Property.allCases) { property in
            HStack {
                Button(property.rawValue) {
                    editedProperty = property
                    presentationMode.wrappedValue.dismiss()
                }
                if property == editedProperty {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }.listStyle(.plain)
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
                NavigationLink(destination: PropertyList(editedProperty: $editedProperty)) {
                    Text("\(editedProperty.rawValue)")
                }
                switch editedProperty {
                case .position:
                    CGPointPropertyEditor(point: $particleEmitter.position)
                case .size:
                    CGSizePropertyEditor(size: $particleEmitter.size)
                case .birthrate:
                    CGFloatPropertyEditor(value: $particleEmitter.birthrate, range: 0 ... 100)
                case .lifetime:
                    CGFloatPropertyEditor(value: $particleEmitter.lifetime, range: 0 ... 20)
                case .velocity:
                    VStack {
                        CGFloatPropertyEditor(value: $particleEmitter.velocity, range: -150 ... 150)
                        CGFloatPropertyEditor(value: $particleEmitter.velocityRange,
                                              range: -100 ... 100)
                    }
                case .color:
                    CompactPickerView(color: $particleEmitter.color)
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
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

struct RoundingFloatSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>

    init(value: Binding<CGFloat>, in range: ClosedRange<CGFloat>) {
        _value = value
        self.range = range
    }

    var body: some View {
        Slider(value: roundingBinding(binding: $value), in: range)
    }

    private func roundingBinding(binding: Binding<CGFloat>) -> Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                binding.wrappedValue
            },
            set: {
                binding.wrappedValue = $0.rounded()
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
