import Foundation

class APIGameFactory: GameFactory {
    private(set) var games: [Game]

    required init() async throws {
        let data = try await Network.shared.load("/games")
        Persistence<Game>().saveToDisk(data)
        let games = try JSONDecoder().decode([Game].self, from: data)
        self.games = games
    }
}
