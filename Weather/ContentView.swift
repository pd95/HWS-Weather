//
//  ContentView.swift
//  Weather
//
//  Created by Philipp on 17.12.21.
//

import SwiftUI

struct ContentView: View {
    @State private var cloudThickness = Cloud.Thickness.regular
    @State private var time = -1.0
    @State private var stormType = Storm.Contents.none
    @State private var rainIntensity = 500.0
    @State private var rainAngle = 0.0

    let dayPhases: [(name: String, startTime: Double)] = [
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

    let backgroundTopStops: [Gradient.Stop] = [
        .init(color: .midnightStart, location: 0),
        .init(color: .midnightStart, location: 0.25),
        .init(color: .sunriseStart, location: 0.33),
        .init(color: .sunnyDayStart, location: 0.38),
        .init(color: .sunnyDayStart, location: 0.7),
        .init(color: .sunsetStart, location: 0.78),
        .init(color: .midnightStart, location: 0.82),
        .init(color: .midnightStart, location: 1),
    ]

    let backgroundBottomStops: [Gradient.Stop] = [
        .init(color: .midnightEnd, location: 0),
        .init(color: .midnightEnd, location: 0.25),
        .init(color: .sunriseEnd, location: 0.33),
        .init(color: .sunnyDayEnd, location: 0.38),
        .init(color: .sunnyDayEnd, location: 0.7),
        .init(color: .sunsetEnd, location: 0.78),
        .init(color: .midnightEnd, location: 0.82),
        .init(color: .midnightEnd, location: 1),
    ]

    let cloudTopStops: [Gradient.Stop] = [
        .init(color: .darkCloudStart, location: 0),
        .init(color: .darkCloudStart, location: 0.25),
        .init(color: .sunriseCloudStart, location: 0.33),
        .init(color: .lightCloudStart, location: 0.38),
        .init(color: .lightCloudStart, location: 0.7),
        .init(color: .sunsetCloudStart, location: 0.78),
        .init(color: .darkCloudStart, location: 0.82),
        .init(color: .darkCloudStart, location: 1),
    ]

    let cloudBottomStops: [Gradient.Stop] = [
        .init(color: .darkCloudEnd, location: 0),
        .init(color: .darkCloudEnd, location: 0.25),
        .init(color: .sunriseCloudEnd, location: 0.33),
        .init(color: .lightCloudEnd, location: 0.38),
        .init(color: .lightCloudEnd, location: 0.7),
        .init(color: .sunsetCloudEnd, location: 0.78),
        .init(color: .darkCloudEnd, location: 0.82),
        .init(color: .darkCloudEnd, location: 1),
    ]

    let starStops: [Gradient.Stop] = [
        .init(color: .white, location: 0),
        .init(color: .white, location: 0.25),
        .init(color: .clear, location: 0.33),
        .init(color: .clear, location: 0.38),
        .init(color: .clear, location: 0.7),
        .init(color: .clear, location: 0.78),
        .init(color: .white, location: 0.82),
        .init(color: .white, location: 1),
    ]

    var starOpacity: Double {
        let color = starStops.interpolated(amount: time)
        return color.getComponents().alpha
    }

    var body: some View {
        ZStack {
            StarsView()
                .opacity(starOpacity)

            CloudsView(
                thickness: cloudThickness,
                topTint: cloudTopStops.interpolated(amount: time),
                bottomTint: cloudBottomStops.interpolated(amount: time)
            )

            if stormType != .none {
                StormView(type: stormType, direction: .degrees(rainAngle), strength: Int(rainIntensity))
            }

            VStack {
                Text(dayPhase)
                Text(formattedTime)
                    .onTapGesture(count: 2, perform: setCurrentTime)
            }
            .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
        .background(LinearGradient(colors: [
            backgroundTopStops.interpolated(amount: time),
            backgroundBottomStops.interpolated(amount: time)
        ], startPoint: .top, endPoint: .bottom))
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                Picker("Thickness", selection: $cloudThickness) {
                    ForEach(Cloud.Thickness.allCases, id: \.self) { thickness in
                        Text(String(describing: thickness).capitalized)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Time:")
                    Slider(value: $time)
                }
                .padding()

                Picker("Precipitation", selection: $stormType) {
                    ForEach(Storm.Contents.allCases, id: \.self) { stormType in
                        Text(String(describing: stormType).capitalized)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Intensity")
                    Slider(value: $rainIntensity, in: 0...1000)
                }
                .padding(.horizontal)

                HStack {
                    Text("Angle:")
                    Slider(value: $rainAngle, in: 0...90)
                }
                .padding(.horizontal)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
        })
        .onAppear {
            if time < 0.0 {
                setCurrentTime()
            }
        }
    }

    var formattedTime: String {
        let start = Calendar.current.startOfDay(for: Date.now)
        let advanced = start.addingTimeInterval(time * 24 * 60 * 60)
        return advanced.formatted(date: .omitted, time: .shortened)
    }

    var dayPhase: String {
        var currentPhase = dayPhases[0]
        for phase in dayPhases {
            if time > phase.startTime  {
                currentPhase = phase
            } else {
                break
            }
        }
        return currentPhase.name.capitalized
    }

    func setCurrentTime() {
        let date = Date.now
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)

        time = ((Double(components.second ?? 0) / 60 +
                 Double(components.minute ?? 0)) / 60 +
                 Double(components.hour ?? 0)) / 24
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
