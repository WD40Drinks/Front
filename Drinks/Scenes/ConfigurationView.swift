import SwiftUI

struct GameToggleView: View {
    let game: Game

    @State var enabled: Bool
    let action: () -> Void

    var body: some View {
        Toggle(game.name, isOn: $enabled)
            .onChange(of: enabled) { _ in
                action()
            }
    }
}

struct ConfigurationView: View {
    @State var teste: Bool = false
//    var games: [Game]
    @StateObject var viewModel: ContentViewModel<MockGameFactory>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(
                        viewModel.games.sorted { $0.name < $1.name },
                        id: \.name
                    ) { game in
                        GameToggleView(game: game, enabled: game.enabled, action: {
                            viewModel.toggleGameEnabled(game)
                        })
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
