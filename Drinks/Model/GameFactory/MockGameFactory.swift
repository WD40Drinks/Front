import Foundation

class MockGameFactory: GameFactory {
    private var nextGameIndex: Int = 0
    private(set) var games: [Game]

    let settings: GameSettings

    required init() async throws {
        self.games = try await Self.decodeGames()
        self.settings = GameSettings(games: games)
    }

    func nextGame() throws -> Game {
        guard !settings.enabledGames.isEmpty else {
            throw GameFactoryError.emptyGameSource
        }

        if let game = settings.enabledGames.get(at: nextGameIndex) {
            nextGameIndex += 1
            return game
        } else {
            nextGameIndex = 1
            return settings.enabledGames[0]
        }
    }

    private static func decodeGames() async throws -> [Game] {
        guard let url = Bundle.main.url(forResource: "Games", withExtension: "json") else {
            print("DEBUG: could not find Games.json")
            throw MockGameFactoryError.mockFileNotFound
        }

        let data = try Data(contentsOf: url)
        let games = try JSONDecoder().decode([[String: Game]].self, from: data)
        if games.isEmpty {
            throw GameFactoryError.emptyGameSource
        }

        let languageIdentifier = Locale.current.twoCharacterId
        let languageFilteredGames = games.compactMap { $0[languageIdentifier] }
        return languageFilteredGames.shuffled()
    }
}

enum MockGameFactoryError: Error {
    case mockFileNotFound
    case problemDecoding
}
