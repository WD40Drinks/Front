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
            onDismiss: viewModel.goToNextGameIfDisabled,
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    configurationButton
                }
            }
        }
    }

    private var nextGameGesture: some Gesture {
        DragGesture().onEnded { value in
            guard !viewModel.isTransitioning else { return }
            let didSwipeHorizontally = abs(value.translation.width) > abs(value.translation.height)
            let didSwipeLeft = value.predictedEndTranslation.width < -60
            if didSwipeHorizontally && didSwipeLeft {
                transitionToNextGame()
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
