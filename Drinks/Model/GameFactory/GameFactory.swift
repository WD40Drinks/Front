import Foundation

protocol GameFactory {
    init() async throws
    var games: [Game] { get }
    var settings: GameSettings { get }
    func nextGame() throws -> Game
}

enum GameFactoryError: Error {
    case emptyGameSource, allGamesDisabled
}
