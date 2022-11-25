import Foundation

protocol GameFactory: AnyObject {
    var games: [Game] { get }
    init() async throws
}
