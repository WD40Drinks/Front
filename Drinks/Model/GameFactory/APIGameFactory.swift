import Foundation

class APIGameFactory: GameFactory {
    private var nextGameIndex: Int = 0
    private(set) var games: [Game]

    var settings: GameSettings

    private var language: String {
        Locale.current.twoCharacterId
    }

    required init() async throws {
        self.games = try await Self.decodeGames()
        self.settings = GameSettings(games: games)
    }

    func nextGame() throws -> Game {
        if let game = games.get(at: nextGameIndex) {
            nextGameIndex += 1
            return game
        } else {
            nextGameIndex = 1
            return games[0]
        }
    }

    private static func decodeGames() async throws -> [Game] {
        let data = try await Network.shared.load("/games")
        let games = try JSONDecoder().decode([Game].self, from: data)

        if games.isEmpty {
            throw GameFactoryError.emptyGameSource
        }

        return games.shuffled()
    }
}
