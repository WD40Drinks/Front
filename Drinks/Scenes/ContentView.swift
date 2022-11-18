import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel<MockGameFactory>()

    var body: some View {
        GridView(color: viewModel.color) {
            switch viewModel.state {
            case .terms:
                TermsView(viewModel: viewModel)
            case .swipe:
                SwipeView(viewModel: viewModel)
            case .loaded(_, let game):
                if !viewModel.isTransitioning {
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
            guard !viewModel.isTransitioning else { return }
            let didSwipeHorizontally = abs(value.translation.width) > abs(value.translation.height)
            let didSwipeLeft = value.predictedEndTranslation.width < -60
            if didSwipeHorizontally && didSwipeLeft {
                switch viewModel.state {
                case .terms:
                    return
                case .swipe:
                    viewModel.initiateGame()
                    // swiftlint:disable:next empty_enum_arguments
                case .loaded(_, _):
                    transitionToNextGame()
                default:
                    return
                }

            }
        }
    }

    private func transitionToNextGame() {
        withAnimation { viewModel.isTransitioning = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            viewModel.goToNextGame()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation { viewModel.isTransitioning = false }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
