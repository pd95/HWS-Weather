//
//  MeteorShower.swift
//  Weather
//
//  Created by Philipp on 15.08.22.
//

import SwiftUI

class MeteorShower {
    enum Constants {
        static let creationDelay = 5.0...10.0
        static let yRange = 100.0...200.0
    }

    var meteors = Set<Meteor>()
    var lastUpdate = Date.now

    var lastCreationDate = Date.now
    var nextCreationDelay = Double.random(in: Constants.creationDelay)

    func update(date: Date, size: CGSize) {
        let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970

        if lastCreationDate + nextCreationDelay < .now {
            createMeteor(in: size)
        }

        // update all meteors
        for meteor in meteors {
            if meteor.isMovingRight {
                meteor.x += delta * meteor.speed
            } else {
                meteor.x -= delta * meteor.speed
            }

            meteor.speed -= delta *  900

            if meteor.speed < 0 {
                meteors.remove(meteor)
            } else if meteor.length < 100 {
                meteor.length += delta * 300
            }
        }

        lastUpdate = date
    }

    func createMeteor(in size: CGSize) {
        let meteor: Meteor

        if Bool.random() {
            meteor = Meteor(x: 0, y: Double.random(in: Constants.yRange), isMovingRight: true)
        } else {
            meteor = Meteor(x: size.width, y: Double.random(in: Constants.yRange), isMovingRight: false)
        }

        meteors.insert(meteor)
        lastCreationDate = .now
        nextCreationDelay = Double.random(in: Constants.creationDelay)
    }
}
