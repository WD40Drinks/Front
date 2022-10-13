//
//  ContentView.swift
//  Drinks
//
//  Created by Leonardo de Sousa Rodrigues on 26/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        GridView(color: .yellow) {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                    .font(.App.title)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
