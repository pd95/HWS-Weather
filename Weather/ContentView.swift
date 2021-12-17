//
//  ContentView.swift
//  Weather
//
//  Created by Philipp on 17.12.21.
//

import SwiftUI

struct ContentView: View {
    @State private var cloudThickness = Cloud.Thickness.regular

    var body: some View {
        ZStack {
            CloudsView(thickness: cloudThickness)
        }
        .preferredColorScheme(.dark)
        .background(Color.blue)
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                Picker("Thickness", selection: $cloudThickness) {
                    ForEach(Cloud.Thickness.allCases, id: \.self) { thickness in
                        Text(String(describing: thickness).capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
