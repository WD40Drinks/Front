import Foundation

class APIGameFactory: GameFactory {
    private(set) var games: [Game]

    required init() async throws {
        let persistence = Persistence<Game>()

        do {
            let data = try await Network.shared.load("/games")
            persistence.saveToDisk(data)
            let games = try JSONDecoder().decode([Game].self, from: data)
            self.games = games
        } catch Network.NetworkError.badRequest {
            self.games = try persistence.loadFromDisk()
        } catch {
            throw error
        }
    }
}
