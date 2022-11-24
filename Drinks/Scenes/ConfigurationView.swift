import SwiftUI

struct GameToggleView: View {
    let game: Game

    @State var enabled: Bool
    let action: () -> Void

    var body: some View {
        Toggle(game.name, isOn: $enabled)
            .onChange(of: enabled) { _ in
                DispatchQueue.main.async {
                    action()
                }
            }
    }
}

struct ConfigurationView: View {
    @ObservedObject var viewModel: ContentViewModel<MockGameFactory>
    @Environment(\.dismiss) var dismiss
    private let rangeOfPlayers: ClosedRange<Int> = 0...10

    var body: some View {
        NavigationView {
            List {

                Section {
                    Picker("num-players", selection: $viewModel.numOfPlayers) {
                        ForEach(rangeOfPlayers, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("num-players")
                }

                if case let .loaded(factory, _) = viewModel.state {
                    Section {
                        ForEach(
                            factory.games.sorted { $0.name < $1.name },
                            id: \.name
                        ) { game in
                            GameToggleView(
                                game: game,
                                enabled: factory.settings.enabledGames.contains(game),
                                action: {
                                    factory.settings.toggle(game)
                                    viewModel.numOfEnabledGames = factory.settings.enabledGames.count
                                }
                            )
                            .disabled(
                                factory.settings.enabledGames.contains(game) &&
                                viewModel.numOfEnabledGames == 1
                            )
                        }
                    } header: {
                        Text("games")
                    }

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
