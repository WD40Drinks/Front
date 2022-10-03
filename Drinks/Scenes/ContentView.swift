import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()

    var body: some View {
        switch viewModel.state {
        case .loaded(_, let game):
            buildGameView(game: game)
        case .loading:
            ProgressView()
        case .error:
            errorView
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
            Text(game.rules)
                .font(.body)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.goToNextGame()
                }, label: {
                    Text("Next")
                })
                .padding()
            }
        }
        .padding()
    }

    private var errorView: some View {
        VStack {
            Text("Could not load view here")
            Button(action: {
                viewModel.createFactoryIfNeeded()
            }, label: {
                Text("Try again")
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
