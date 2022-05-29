// Copyright © 2022 Wojciech Czerski. All rights reserved.

extension PropertyInfo {
    static let position = PropertyInfo(
        name: "Position",
        description: "The position of the center of the particle emitter."
    )

    static let size = PropertyInfo(
        name: "Size",
        description: "Determines the size of the particle emitter shape."
    )

    static let birthrate = PropertyInfo(
        name: "Birthrate",
        description: "The position of the center of the particle emitter."
    )

    static let lifetime = PropertyInfo(
        name: "Lifetime",
        description: "The lifetime of the cell, in seconds."
    )

    static let velocity = PropertyInfo(
        name: "Velocity",
        description: "The initial velocity of the cell."
    )

    static let velocityRange = PropertyInfo(
        name: "Velocity Range",
        description: "The amount by which the velocity of the cell can vary."
    )

    static let color = PropertyInfo(
        name: "Color",
        description: "The color of each emitted object."
    )

    static let emissionLongitude = PropertyInfo(
        name: "Emission Longitude",
        description: "The longitudinal orientation of the emission angle."
    )

    static let emissionRange = PropertyInfo(
        name: "Emission Range",
        description: "The angle, in radians, defining a cone around the emission angle."
    )

    static let scale = PropertyInfo(
        name: "Scale",
        description: "Specifies the scale factor applied to the cell."
    )

    static let scaleRange = PropertyInfo(
        name: "Scale Range",
        description: "Specifies the range over which the scale value can vary."
    )

    static let scaleSpeed = PropertyInfo(
        name: "Scale Speed",
        description: "The speed at which the scale changes over the lifetime of the cell."
    )
}
