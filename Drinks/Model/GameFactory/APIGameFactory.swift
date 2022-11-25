import Foundation

class APIGameFactory: GameFactory {
    private(set) var games: [Game]

    required init() async throws {
        let data = try await Network.shared.load("/games")
        let games = try JSONDecoder().decode([Game].self, from: data)

        if games.isEmpty {
            throw GameManagerError.emptyGameSource
        }

        self.games = games
    }
}
