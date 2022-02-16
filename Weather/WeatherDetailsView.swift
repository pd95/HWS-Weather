//
//  WeatherDetailsView.swift
//  Weather
//
//  Created by Philipp on 16.02.22.
//

import SwiftUI

struct WeatherDetailsView: View {
    let time: Double
    let tintColor: Color
    let residueType: Storm.Contents
    let residueStrength: Double

    static private let dayPhases: [(name: String, startTime: Double)] = [
        ("midnight", 0),
        ("night", 1.0/24),
        ("sunrise", 6.5/24),
        ("morning", 8.0/24),
        ("noon", 11.5/24),
        ("afternoon", 13.0/24),
        ("sunset", 17.5/24),
        ("evening", 19.0/24),
        ("night", 22.0/24),
        ("midnight", 23.5/24)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ResidueView(type: residueType, strength: residueStrength)
                    .frame(height: 62)
                    .offset(y: 30)
                    .zIndex(1)

                RoundedRectangle(cornerRadius: 25)
                    .fill(tintColor.opacity(0.25))
                    .frame(height: 800)
                    .background(.ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 25))
                    .overlay(detailContent, alignment: .top)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 200)
        }
    }

    private var detailContent: some View {
        VStack {
            Text(dayPhase)
            Text(formattedTime)
        }
        .font(.largeTitle)
        .padding()
    }

    private var formattedTime: String {
        let start = Calendar.current.startOfDay(for: Date.now)
        let advanced = start.addingTimeInterval(time * 24 * 60 * 60)
        return advanced.formatted(date: .omitted, time: .shortened)
    }

    private var dayPhase: String {
        var currentPhase = WeatherDetailsView.dayPhases[0]
        for phase in WeatherDetailsView.dayPhases {
            if time > phase.startTime  {
                currentPhase = phase
            } else {
                break
            }
        }
        return currentPhase.name.capitalized
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailsView(time: 0, tintColor: .blue, residueType: .rain, residueStrength: 800)
            .background(Color.black)
    }
}
