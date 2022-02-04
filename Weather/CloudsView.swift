//
//  CloudsView.swift
//  Weather
//
//  Created by Philipp on 17.12.21.
//

import SwiftUI

struct CloudsView: View {
    let thickness: Cloud.Thickness
    let topTint: Color
    let bottomTint: Color

    @State private var cloudGroup = CloudGroup()

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                cloudGroup.update(date: timeline.date)
                context.opacity = cloudGroup.opacity

                let resolvedImages = (0..<8).map { i -> GraphicsContext.ResolvedImage in
                    let sourceImage = Image("cloud\(i)")
                    var resolved = context.resolve(sourceImage)

                    resolved.shading = .linearGradient(
                        Gradient(
                            colors: [topTint, bottomTint]),
                        startPoint: .zero,
                        endPoint: CGPoint(x: 0, y: resolved.size.height)
                    )
                    return resolved
                }

                for cloud in cloudGroup.clouds {
                    context.translateBy(x: cloud.position.x, y: cloud.position.y)
                    context.scaleBy(x: cloud.scale, y: cloud.scale)
                    context.draw(resolvedImages[cloud.imageNumber], at: .zero, anchor: .topLeading)
                    context.transform = .identity
                }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: thickness) { newValue in
            withAnimation {
                cloudGroup.update(thickness: newValue)
            }
        }
        .onAppear {
            cloudGroup.update(thickness: thickness)
        }
    }
}

struct CloudsView_Previews: PreviewProvider {
    static var previews: some View {
        CloudsView(thickness: .regular, topTint: .white, bottomTint: .white)
            .background(Color.blue)
    }
}
