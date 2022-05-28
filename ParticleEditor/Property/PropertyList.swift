// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct PropertyList: View {
    let emitter: ParticleEmitter
    let properties: [EmitterProperty]
    @Binding var editedProperty: EmitterProperty
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        List(properties, id: \.displayName) { property in
            VStack(alignment: .leading) {
                HStack {
                    Button(property.displayName) {
                        editedProperty = property
                        presentationMode.wrappedValue.dismiss()
                    }
                    if property.displayName == editedProperty.displayName {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
                Text(property.valueText)
                    .font(.footnote)
            }
        }
    }
}
