import Foundation

class MockGameFactory: GameFactory {
    static let key = "disabled_games"

    private var nextGameIndex: Int = 0
    private(set) var games: [Game]

    required init() async throws {
        self.games = try await Self.decodeGames()
        setDisabledGames()
    }

    func currentGame() throws -> Game {
        if let game = games.get(at: nextGameIndex - 1) {
            return game
        }
        return try firstEnabledGame()
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

    private func firstEnabledGame() throws -> Game {
        guard let idx = games.indices.first(where: { !disabledGamesIndex.contains($0) }) else {
            throw GameFactoryError.allGamesDisabled
        }
        return games[idx]
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
            let game = try firstEnabledGame()
            nextGameIndex = (games.firstIndex(where: { $0 == game }) ?? 0) + 1
            return game
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
