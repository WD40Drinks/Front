import Foundation

class MockGameFactory: GameFactory {
    private var nextGameIndex: Int = 0
    private var games: [Game]

    required init() async throws {
        guard let url = Bundle.main.url(forResource: "Games", withExtension: "json") else {
            print("DEBUG: could not find Games.json")
            throw MockGameFactoryError.mockFileNotFound
        }

        let data = try Data(contentsOf: url)
        let games = try JSONDecoder().decode([Game].self, from: data)
        if games.isEmpty {
            throw GameFactoryError.emptyGameSource
        }

        self.games = games
    }

    func nextGame() throws -> Game {
        guard !games.isEmpty else {
            throw GameFactoryError.emptyGameSource
        }

        if let game = games.get(at: nextGameIndex) {
            nextGameIndex += 1
            return game
        } else {
            nextGameIndex = 1
            return games[0]
        }
    }
}

enum MockGameFactoryError: Error {
    case mockFileNotFound
    case problemDecoding
}
