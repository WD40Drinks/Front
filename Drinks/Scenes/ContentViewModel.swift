import SwiftUI

class ContentViewModel<Factory: GameFactory>: ObservableObject {
    enum State {
        case loading
        case error
        case terms
        case swipe
        case loaded(GameManager, Game)
    }

    @Published var state: State
    @Published var color: Color.App
    @Published var numOfPlayers: Int
    @Published var numOfEnabledGames: Int
    @Published var isTransitioning = false

    private var factory: Factory?

    init() {
        self.state = .terms
        self.color = .yellow
        self.numOfPlayers = 5
        self.numOfEnabledGames = 0
        Task {
            self.factory = try await Factory()
        }
    }

    //MARK: - Public

    func createManagerIfNeeded() {
        switch state {
        case .error:
            createManager()
        default:
            return
        }
    }

    /// Used when the user disables the current game in ConfigurationView
    func goToNextGameIfDisabled() {
        if
            case .loaded(let manager, let game) = state,
            !manager.settings.enabledGames.contains(game)
        {
            goToNextGame()
        }
    }

    func goToNextGame() {
        switch state {
        case .loaded(let manager, _):
            goToNextGame(manager: manager)
        case .swipe:
            createManager()
        default:
            print("DEBUG: Could not go to next game in state different from loaded")
            return
        }
    }

    func goToTutorial() {
        setState(.swipe)
    }

    //MARK: - Private

    private func createManager() {
        let manager = GameManager(games: factory?.games.shuffled() ?? [])
        self.numOfEnabledGames = manager.settings.enabledGames.count
        goToNextGame(manager: manager)
    }

    private func goToNextGame(manager: GameManager) {
        guard let nextGame = try? manager.nextGame() else {
            print("DEBUG: Could not get next game from factory")
            setState(.error)
            return
        }

        setState(.loaded(manager, nextGame))
        setColor(.random)
    }

    private func setState(_ state: State) {
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
