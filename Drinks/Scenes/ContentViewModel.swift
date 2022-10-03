import SwiftUI

extension ContentView {
    enum ViewModelState {
        case loading
        case error
        case loaded(GameFactory, Game)
    }

    class ViewModel: ObservableObject {
        @Published var state: ViewModelState = .loading

        init() {
            createFactory()
        }

        func createFactoryIfNeeded() {
            switch state {
            case .error:
                createFactory()
            default:
                return
            }
        }

        private func createFactory() {
            Task {
                do {
                    let factory = try await MockGameFactory()
                    let game = try factory.nextGame()
                    DispatchQueue.main.async {
                        self.state = .loaded(factory, game)
                    }
                } catch {
                    print("DEBUG: failed creating game factory")
                    DispatchQueue.main.async {
                        self.state = .error
                    }
                }
            }
        }

        func goToNextGame() {
            switch state {
            case .loaded(let factory, _):
                guard let nextGame = try? factory.nextGame() else {
                    print("DEBUG: Could not get next game from factory")
                    return
                }

                DispatchQueue.main.async {
                    self.state = .loaded(factory, nextGame)
                }
            default:
                return
            }
        }
    }
}
