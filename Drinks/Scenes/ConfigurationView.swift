//
//  ConfigurationView.swift
//  Drinks
//
//  Created by Gabriel Muelas on 07/11/22.
//

import SwiftUI

struct ConfigurationView: View {
    @State var teste: Bool = false
//    var games: [Game]
    @StateObject var viewModel: ContentViewModel<MockGameFactory>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.games, id: \.name) { game in
                        Toggle(game.name, isOn: $teste)
                    }
                } header: {
                    Text("games")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("configs")
            .toolbar {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView(viewModel: ContentViewModel<MockGameFactory>())
    }
}
