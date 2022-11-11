import Foundation

struct Game: Decodable, Equatable {
    let name: String
    let text: String?
    let imageName: String
    let rules: String?
    let suggestions: [String]?
    let timer: Int?
    let minigameToken: String?
}
