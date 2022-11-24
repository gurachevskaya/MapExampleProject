//
//  ContentView.swift
//  MapExampleProject
//
//  Created by Karina gurachevskaya on 23.11.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView(places: MapDirectory().places)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
