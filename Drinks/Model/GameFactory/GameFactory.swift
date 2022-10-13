import Foundation

protocol GameFactory {
    init() async throws
    func nextGame() throws -> Game
}

enum GameFactoryError: Error {
    case emptyGameSource
}
