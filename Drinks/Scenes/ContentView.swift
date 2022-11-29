import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel<MockGameFactory>()
    @State private var presentConfiguration = false
    @State private var isShowingInteractiveGame = false

    var topBar: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        presentConfiguration.toggle()
                    },
                    label: {
                        Image("gearshape.stroke")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.black, viewModel.color.primary)
                            .font(.title)
                    }
                )
                .sheet(
                    isPresented: $presentConfiguration,
                    onDismiss: viewModel.goToNextGameIfDisabled,
                    content: {
                        ConfigurationView(viewModel: viewModel)
                    }
                )

                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .edgesIgnoringSafeArea(.all)
    }

    var body: some View {
        GridView(color: viewModel.color) {
            ZStack(alignment: .top) {
                switch viewModel.state {
                case .terms:
                    TermsView(viewModel: viewModel)
                case .swipe:
                    SwipeView(viewModel: viewModel)
                case .loaded(_, let game):
                    topBar
                    if !viewModel.isTransitioning {
                        GameView(game: game, isShowingInteractiveGame: $isShowingInteractiveGame)
                            .transition(.push(from: .trailing))
                    }
                case .loading:
                    ProgressView()
                case .error:
                    ErrorView(tryAgainButtonAction: viewModel.createFactoryIfNeeded)
                }
            }

        }
        .gesture(nextGameGesture)
        .appColor(viewModel.color)
    }

    private var nextGameGesture: some Gesture {
        DragGesture().onEnded { value in
            guard !viewModel.isTransitioning else { return }
            guard !isShowingInteractiveGame else { return }
            let didSwipeHorizontally = abs(value.translation.width) > abs(value.translation.height)
            let didSwipeLeft = value.predictedEndTranslation.width < -60
            if didSwipeHorizontally && didSwipeLeft {
                switch viewModel.state {
                case .swipe:
                    viewModel.initiateGame()
                case .loaded:
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
