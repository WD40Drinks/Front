import SwiftUI

class ContentViewModel<Factory: GameFactory, Handler: ImageHandler>: ObservableObject {
    enum State {
        case loading
        case error
        case loaded(Factory, Game)
    }

    @Published var state: State
    @Published var image: UIImage?
    private let imageHandler: Handler

    init() {
        self.state = .loading
        self.imageHandler = Handler()
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
            guard let factory = try? await Factory() else {
                print("DEBUG: failed creating game factory")
                setState(.error)
                return
            }

            goToNextGame(factory: factory)
        }
    }

    func goToNextGame() {
        switch state {
        case .loaded(let factory, _):
            goToNextGame(factory: factory)
        default:
            return
        }
    }

    private func goToNextGame(factory: Factory) {
        guard let nextGame = try? factory.nextGame() else {
            print("DEBUG: Could not get next game from factory")
            setState(.error)
            return
        }

        setState(.loaded(factory, nextGame))
        fetchImage(game: nextGame)
    }

    private func fetchImage(game: Game) {
        DispatchQueue.main.async {
            self.image = nil
        }

        let handler = Handler()
        Task {
            let image = await handler.getImage(name: game.imageName)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    private func setState(_ state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
