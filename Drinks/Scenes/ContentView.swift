import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel<MockGameFactory, MockImageHandler>()

    var body: some View {
        GridView(color: .yellow) {
            switch viewModel.state {
            case .loaded(_, let game):
                buildGameView(game: game)
            case .loading:
                ProgressView()
            case .error:
                errorView
            }
        }
    }

    private func buildGameView(game: Game) -> some View {
        VStack {
            Text(game.name)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Text(game.text)
                .foregroundColor(.gray)
                .font(.title3)
            Spacer()
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 300, height: 200)
            Spacer()
            if let rules = game.rules {
                Text(rules)
                    .font(.body)
                Spacer()
            }
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
        .padding()
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
