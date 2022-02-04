//
//  CloudGroup.swift
//  Weather
//
//  Created by Philipp on 17.12.21.
//

import Foundation

class CloudGroup {
    var clouds = [Cloud]()
    var opacity: Double = 0.0
    var lastUpdate = Date.now

    func update(thickness: Cloud.Thickness) {
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

        // Remove clouds which are superfluous
        let cloudsToRemove = clouds.count - cloudsToCreate
        if cloudsToRemove > 0 {
            clouds.removeLast(cloudsToRemove)
        }

        // Update scale of all clouds we keep
        for cloud in clouds {
            cloud.update(scale: Double.random(in: cloudScale))
        }

        // Add new clouds if we haven't enough
        for i in clouds.count..<cloudsToCreate {
            let scale = Double.random(in: cloudScale)
            let imageNumer = i % 8

            let cloud = Cloud(imageNumber: imageNumer, scale: scale)
            clouds.append(cloud)
        }

        // make the array appear random
        clouds.shuffle()
    }

    func update(date: Date) {
        let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970

        for cloud in clouds {
            cloud.position.x -= delta * cloud.speed

            let offScreenDistance = max(400, 400 * cloud.scale)

            if cloud.position.x < -offScreenDistance {
                cloud.position.x = offScreenDistance
            }
        }

        lastUpdate = date
    }
}
