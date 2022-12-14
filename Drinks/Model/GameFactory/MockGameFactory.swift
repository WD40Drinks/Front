import Foundation

class MockGameFactory: GameFactory {
    private(set) var games: [Game]

    required init() async throws {
        guard let url = Bundle.main.url(forResource: "Games", withExtension: "json") else {
            print("DEBUG: could not find Games.json")
            throw MockGameFactoryError.mockFileNotFound
        }

        let data = try Data(contentsOf: url)
        let games = try JSONDecoder().decode([[String: Game]].self, from: data)
        if games.isEmpty {
            throw GameManagerError.emptyGameSource
        }

        let languageIdentifier = Locale.current.twoCharacterId
        let languageFilteredGames = games.compactMap { $0[languageIdentifier] }
        self.games = languageFilteredGames
    }
}

enum MockGameFactoryError: Error {
    case mockFileNotFound
    case problemDecoding
}
