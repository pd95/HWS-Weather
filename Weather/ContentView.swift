//
//  ContentView.swift
//  Weather
//
//  Created by Philipp on 17.12.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            CloudsView(thickness: .regular)
        }
        .preferredColorScheme(.dark)
        .background(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
