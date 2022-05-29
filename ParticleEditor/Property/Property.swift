// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct PropertyInfo {
    let name: String
    let description: String
}

protocol EmitterProperty {
    var info: PropertyInfo { get }
    var valueText: String { get }
    var editorView: AnyView { get }
}

struct CGFloatEmitterProperty: EmitterProperty {
    let info: PropertyInfo
    let property: EmitterPropertyReference<CGFloat>
    let range: ClosedRange<CGFloat>

    var valueText: String {
        String(describing: property.value)
    }

    var editorView: AnyView {
        return AnyView(CGFloatPropertyEditor(value: property.binding, range: range))
    }
}

struct CGFloatAngleEmitterProperty: EmitterProperty {
    let info: PropertyInfo
    let property: EmitterPropertyReference<CGFloat>
    let range: ClosedRange<CGFloat>

    var valueText: String {
        String(describing: property.value.degrees)
    }

    var editorView: AnyView {
        return AnyView(CGFloatAnglePropertyEditor(radians: property.binding, range: range))
    }
}

struct ColorEmitterProperty: EmitterProperty {
    let info: PropertyInfo
    let property: EmitterPropertyReference<Color>

    var valueText: String {
        String(describing: property.value)
    }

    var editorView: AnyView {
        return AnyView(CompactPickerView(color: property.binding))
    }
}

struct CGSizeEmitterProperty: EmitterProperty {
    let info: PropertyInfo
    let property: EmitterPropertyReference<CGSize>

    var valueText: String {
        String(describing: property.value)
    }

    var editorView: AnyView {
        return AnyView(CGSizePropertyEditor(size: property.binding))
    }
}

struct CGPointEmitterProperty: EmitterProperty {
    let info: PropertyInfo
    let property: EmitterPropertyReference<CGPoint>

    var valueText: String {
        String(describing: property.value)
    }

    var editorView: AnyView {
        return AnyView(CGPointPropertyEditor(point: property.binding))
    }
}

struct EmitterPropertyReference<T> {
    let emitter: ParticleEmitter
    let keyPath: ReferenceWritableKeyPath<ParticleEmitter, T>

    var value: T {
        emitter[keyPath: keyPath]
    }

    var binding: Binding<T> {
        .init(get: {
            emitter[keyPath: keyPath]
        }, set: {
            emitter[keyPath: keyPath] = $0
        })
    }
}

extension ParticleEmitter {
    func property<T>(_ keyPath: ReferenceWritableKeyPath<ParticleEmitter, T>) -> EmitterPropertyReference<T> {
        .init(emitter: self, keyPath: keyPath)
    }
}
