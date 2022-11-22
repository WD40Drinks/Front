import Foundation

struct Game: Decodable, Equatable {
    let id: UUID
    let pt: GameContent
    let en: GameContent
    let colorImageURL: String?
    let foregroundImageURL: String?
    let timer: Int?
    let minigameToken: String?
}

struct GameContent: Decodable, Equatable {
    let name: String
    let text: String?
    let suggestions: [String]?
    let rules: String?
}
