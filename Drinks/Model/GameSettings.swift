import Foundation

class GameSettings {
    private static let key = "enabled_games_id"
    private var settings: UserDefaults { UserDefaults.standard }

    private let games: [Game]

    private(set) var enabledGames: [Game] {
        get {
            guard let ids = settings.array(forKey: Self.key) as? [String] else {
                return games
            }
            return games.filter { ids.contains($0.id.uuidString) }
        }
        set {
            settings.set(newValue.map { $0.id.uuidString }, forKey: Self.key)
        }
    }

    init(games: [Game]) {
        self.games = games
    }

    private func enable(_ game: Game) {
        enabledGames.append(game)
    }

    private func disable(_ game: Game) {
        enabledGames.removeAll { $0 == game }
    }

    func toggle(_ game: Game) {
        if enabledGames.contains(game) {
            disable(game)
        } else {
            enable(game)
        }
    }
}
