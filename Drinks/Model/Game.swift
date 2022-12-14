import Foundation

enum Language: String {
    case pt, en
}

struct Game: Codable, Equatable {
    static var language: Language {
        Language(rawValue: Locale.current.twoCharacterId) ?? .en
    }

    let id: UUID
    let name: String
    let text: String?
    let suggestions: [String]?
    let rules: String?
    let colorImageURL: String?
    let foregroundImageURL: String?
    let timer: Int?
    let minigameToken: MinigameToken?

    private enum OuterKeys: String, CodingKey {
        case id, colorImageURL, foregroundImageURL, timer, minigameToken
        case pt, en
    }

    private enum ContentKeys: String, CodingKey {
        case name, text, suggestions, rules
    }

    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        var contentContainer: KeyedDecodingContainer<ContentKeys>

        self.id = try outerContainer.decode(UUID.self, forKey: .id)
        self.colorImageURL = try outerContainer.decodeIfPresent(String.self, forKey: .colorImageURL)
        self.foregroundImageURL = try outerContainer.decodeIfPresent(String.self, forKey: .foregroundImageURL)
        self.timer = try outerContainer.decodeIfPresent(Int.self, forKey: .timer)
        self.minigameToken = try outerContainer.decodeIfPresent(MinigameToken.self, forKey: .minigameToken)

        switch Self.language {
        case .pt:
            contentContainer = try outerContainer.nestedContainer(keyedBy: ContentKeys.self, forKey: .pt)
        case .en:
            contentContainer = try outerContainer.nestedContainer(keyedBy: ContentKeys.self, forKey: .en)
        }

        self.name = try contentContainer.decode(String.self, forKey: .name)
        self.text = try contentContainer.decodeIfPresent(String.self, forKey: .text)
        self.suggestions = try contentContainer.decodeIfPresent([String].self, forKey: .suggestions)
        self.rules = try contentContainer.decodeIfPresent(String.self, forKey: .rules)
    }
}
