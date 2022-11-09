import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel<MockGameFactory>()
    @State private var isTransitioning = false

    var body: some View {
        GridView(color: viewModel.color) {
            switch viewModel.state {
            case .loaded(_, let game):
                if !isTransitioning {
                    GameView(game: game)
                        .transition(.push(from: .trailing))
                }
            case .loading:
                ProgressView()
            case .error:
                ErrorView(tryAgainButtonAction: viewModel.createFactoryIfNeeded)
            }
        }
        .gesture(nextGameGesture)
        .appColor(viewModel.color)
    }

    private var nextGameGesture: some Gesture {
        DragGesture().onEnded { value in
            guard !isTransitioning else { return }
            let didSwipeHorizontally = abs(value.translation.width) > abs(value.translation.height)
            let didSwipeLeft = value.predictedEndTranslation.width < -60
            if didSwipeHorizontally && didSwipeLeft {
                transitionToNextGame()
            }
        }
    }

    private func transitionToNextGame() {
        withAnimation { isTransitioning = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            viewModel.goToNextGame()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation { isTransitioning = false }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
