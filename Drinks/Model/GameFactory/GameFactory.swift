import Foundation

protocol GameFactory {
    init() async throws
    var games: [Game] { get }
    func nextGame() throws -> Game
}

enum GameFactoryError: Error {
    case emptyGameSource
}
