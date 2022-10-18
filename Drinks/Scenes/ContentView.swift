import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel<MockGameFactory>()

    var body: some View {
        GridView(color: viewModel.color) {
            switch viewModel.state {
            case .loaded(_, let game):
                buildGameView(game: game)
            case .loading:
                ProgressView()
            case .error:
                errorView
            }
        }
        .appColor(viewModel.color)
    }

    private func buildGameView(game: Game) -> some View {
        VStack {
            Spacer()
            Text(game.name)
                .font(.App.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
            if let text = game.text {
                GameTextView(text: text)
                    .offset(x: -30)
                Spacer()
            }
            ColoredImage(imageName: game.imageName)
                .frame(width: 300, height: 200)
            Spacer()
            nextButton
        }
        .padding()
    }

    private var nextButton: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.goToNextGame()
            }, label: {
                Text("next")
            })
            .padding()
        }
    }

    private var errorView: some View {
        VStack {
            Text("view-not-loaded")
            Button(action: {
                viewModel.createFactoryIfNeeded()
            }, label: {
                Text("try-again")
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
