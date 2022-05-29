// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

struct PropertyList: View {
    let emitter: ParticleEmitter
    let properties: [EmitterProperty]
    @Binding var editedProperty: EmitterProperty
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        List(properties, id: \.info.name) { property in
            HStack {
                VStack(alignment: .leading) {
                    Button {
                        editedProperty = property
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        if property.info.name == editedProperty.info.name {
                            Text(property.info.name)
                                .bold()
                        } else {
                            Text(property.info.name)
                                .foregroundColor(Color.black)
                        }
                    }
                    Text(property.info.description)
                        .font(.footnote)
                }
                Spacer()
                Text(property.valueText)
            }
        }
    }
}
