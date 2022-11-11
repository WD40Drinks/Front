import SwiftUI

class ContentViewModel<Factory: GameFactory>: ObservableObject {
    enum State {
        case loading
        case error
        case loaded(Factory, Game)
    }

    @Published var state: State
    @Published var color: Color.App
    @Published var presentConfiguration: Bool

    init() {
        self.state = .loading
        self.color = .red
        self.presentConfiguration = false
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
        setColor(.random)
    }
    
    private func setState(_ state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }

    private func setColor(_ color: Color.App) {
        DispatchQueue.main.async {
            self.color = color
        }
    }
}
