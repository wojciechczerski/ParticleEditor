// Copyright © 2022 Wojciech Czerski. All rights reserved.

import SwiftUI

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
