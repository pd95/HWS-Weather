//
//  LightningView.swift
//  Weather
//
//  Created by Philipp on 20.03.22.
//

import SwiftUI

struct LightningView: View {

    var lightning: Lightning

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                lightning.update(date: timeline.date, in: size)

                let fullScreen = Path(CGRect(origin: .zero, size: size))
                context.fill(fullScreen, with: .color(.white.opacity(lightning.flashOpacity)))

                for _ in 0..<2 {
                    for bolt in lightning.bolts {
                        var path = Path()
                        path.addLines(bolt.points)

                        context.stroke(path, with: .color(.white), lineWidth: bolt.width)
                    }

                    context.addFilter(.blur(radius: 5))
                }
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            lightning.strike()
        }
    }

    init() {
        lightning = Lightning()
    }
}

struct LightningView_Previews: PreviewProvider {
    static var previews: some View {
        LightningView()
    }
}
