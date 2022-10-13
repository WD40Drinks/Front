import Foundation

extension Locale {

    var twoCharacterId: String {
        let identifier = String(self.identifier.prefix(2))
        if identifier.count == 2 {
            return identifier
        } else {
            return "en"
        }
    }

}
