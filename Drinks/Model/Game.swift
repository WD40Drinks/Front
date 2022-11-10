import Foundation

struct Game: Decodable, Equatable {
    let name: String
    let text: String?
    let imageName: String
    let rules: String?
    let suggestions: [String]?
    let timer: Int?
    let minigameToken: String?

    var enabled: Bool {
        guard
            let array = UserDefaults.standard.array(forKey: MockGameFactory.key),
            let disabled = array as? [String]
        else {
            return true
        }

        return !disabled.contains(name)
    }
}
