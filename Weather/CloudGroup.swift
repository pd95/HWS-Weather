//
//  CloudGroup.swift
//  Weather
//
//  Created by Philipp on 17.12.21.
//

import Foundation

class CloudGroup {
    var clouds = [Cloud]()
    let opacity: Double

    init(thickness: Cloud.Thickness) {
        let cloudsToCreate: Int
        let cloudScale: ClosedRange<Double>

        switch thickness {
        case .none:
            cloudsToCreate = 0
            opacity = 1
            cloudScale = 1...1
        case .thin:
            cloudsToCreate = 10
            opacity = 0.6
            cloudScale = 0.2...0.4
        case .light:
            cloudsToCreate = 10
            opacity = 0.7
            cloudScale = 0.4...0.6
        case .regular:
            cloudsToCreate = 15
            opacity = 0.8
            cloudScale = 0.7...0.9
        case .thick:
            cloudsToCreate = 25
            opacity = 0.9
            cloudScale = 1...1.3
        case .ultra:
            cloudsToCreate = 40
            opacity = 1
            cloudScale = 1.2...1.6
        }

        for i in 0..<cloudsToCreate {
            let scale = Double.random(in: cloudScale)
            let imageNumer = i % 8

            let cloud = Cloud(imageNumber: imageNumer, scale: scale)
            clouds.append(cloud)
        }
    }
}
