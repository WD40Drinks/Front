import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel<MockGameFactory>()

    var configurationButton: some View {
        Button(
            action: {
                viewModel.presentConfiguration.toggle()
            },
            label: {
                Image("gearshape.stroke")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.black, viewModel.color.primary)
            }
        )
        .sheet(
            isPresented: $viewModel.presentConfiguration,
            onDismiss: {
                if
                    case .loaded(let factory, let game) = viewModel.state,
                    !factory.settings.enabledGames.contains(game)
                {
                    viewModel.goToNextGame()
                }
            },
            content: {
                ConfigurationView(viewModel: viewModel)
            }
        )
    }

    var body: some View {
        NavigationView {
            GridView(color: viewModel.color) {
                switch viewModel.state {
                case .loaded(_, let game):
                    GameView(game: game, nextButtonAction: viewModel.goToNextGame)
                case .loading:
                    ProgressView()
                case .error:
                    ErrorView(tryAgainButtonAction: viewModel.createFactoryIfNeeded)
                }
            }
            .appColor(viewModel.color)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    configurationButton
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
