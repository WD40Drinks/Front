import SwiftUI

class ContentViewModel<Factory: GameFactory>: ObservableObject {
    enum State {
        case loading
        case error
        case terms
        case swipe
        case loaded(Factory, Game)
    }

    @Published var state: State
    @Published var color: Color.App
    @Published var numOfPlayers: Int
    @Published var numOfEnabledGames: Int
    @Published var isTransitioning = false

    init() {
        self.state = .loading
        self.color = .red
        initiateOnboarding()
    }

    func initiateOnboarding() {
        setState(.terms)
    }

    func initiateGame() {
        self.numOfPlayers = 5
        self.numOfEnabledGames = 0
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

    func goToNextGameIfDisabled() {
        if
            case .loaded(let factory, let game) = state,
            !factory.settings.enabledGames.contains(game)
        {
            goToNextGame()
        }
    }

    private func createFactory() {
        Task {
            guard let factory = try? await Factory() else {
                print("DEBUG: failed creating game factory")
                setState(.error)
                return
            }

            DispatchQueue.main.async {
                self.numOfEnabledGames = factory.settings.enabledGames.count
            }

            goToNextGame(factory: factory)
        }
    }

    func goToNextGame() {
        switch state {
        case .loaded(let factory, _):
            goToNextGame(factory: factory)
        default:
            print("DEBUG: Could not go to next game in state different from loaded")
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

    func setState(_ state: State) {
        DispatchQueue.main.async {
            withAnimation { self.state = state }
        }
    }

    private func setColor(_ color: Color.App) {
        DispatchQueue.main.async {
            withAnimation { self.color = color }
        }
    }
}
