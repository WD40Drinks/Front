import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel<MockGameFactory>()

    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
