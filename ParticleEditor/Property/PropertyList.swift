// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct PropertyList: View {
    let emitter: ParticleEmitter
    let properties: [EmitterProperty]
    @Binding var editedProperty: EmitterProperty
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        List(properties, id: \.name) { property in
            HStack {
                VStack(alignment: .leading) {
                    Button {
                        editedProperty = property
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        if property.name == editedProperty.name {
                            Text(property.name)
                                .bold()
                        } else {
                            Text(property.name)
                                .foregroundColor(Color.black)
                        }
                    }
                    Text(property.info)
                        .font(.footnote)
                }
                Spacer()
                Text(property.valueText)
            }
        }
    }
}
