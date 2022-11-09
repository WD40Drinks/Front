import Foundation

class MockGameFactory: GameFactory {
    static let key = "disabled_games"

    private var nextGameIndex: Int = 0
    private(set) var games: [Game]

    required init() async throws {
        self.games = try await Self.decodeGames()
        setDisabledGames()
    }

    private var disabledGamesIndex: [Int] = []
    func toggleGameEnabled(_ game: Game) {
        guard let idx = games.firstIndex(where: { game.name == $0.name }) else {
            print("DEBUG: Could not find game")
            return
        }

        if disabledGamesIndex.contains(idx) {
            // enable
            disabledGamesIndex.removeAll { $0 == idx }
            UserDefaults.standard.removeAll(where: { ($0 as? String) == game.name }, forKey: Self.key)
        } else {
            // disable
            disabledGamesIndex.append(idx)
            UserDefaults.standard.append(game.name, forKey: Self.key)
        }
    }

    private func setDisabledGames() {
        guard
            let array = UserDefaults.standard.array(forKey: Self.key),
            let disabledGamesName = array as? [String]
        else {
            return
        }

        disabledGamesIndex = games.indices.filter { disabledGamesName.contains(games[$0].name) }
    }

    func nextGame() throws -> Game {
        guard !games.isEmpty else {
            throw GameFactoryError.emptyGameSource
        }

        while disabledGamesIndex.contains(nextGameIndex) {
            nextGameIndex += 1
        }

        if let game = games.get(at: nextGameIndex) {
            nextGameIndex += 1
            return game
        } else {
            nextGameIndex = 1
            return games[0]
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
