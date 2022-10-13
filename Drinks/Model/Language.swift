import Foundation

enum Language: String, CaseIterable {
    case portuguese = "pt"
    case english = "en"

    static func preferredLanguage() -> Language {
        let preferredIdentifiers = Locale.preferredLanguages.map { String($0.prefix(2)) }
        let identifier = preferredIdentifiers.first { id in
            Self.allCases.contains { $0.rawValue == id }
        }

        if
            let identifier,
            let language = Language(rawValue: identifier)
        {
            return language
        } else {
            return .english
        }
    }
}
