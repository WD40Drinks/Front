import Foundation

class GameManager {
    private var nextGameIndex: Int = 0
    private(set) var games: [Game]

    var settings: GameSettings

    init(games: [Game]) {
        self.games = games
        self.settings = GameSettings(games: games)
    }

    func nextGame() throws -> Game {
        guard !settings.enabledGames.isEmpty else {
            throw GameManagerError.emptyGameSource
        }

        if let game = settings.enabledGames.get(at: nextGameIndex) {
            nextGameIndex += 1
            return game
        } else {
            nextGameIndex = 1
            return settings.enabledGames[0]
        }
    }
}

enum GameManagerError: Error {
    case emptyGameSource, allGamesDisabled
}
