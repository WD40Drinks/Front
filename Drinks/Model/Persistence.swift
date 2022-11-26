import Foundation

class Persistence<Model: Codable> {
    private let manager: FileManager
    private let fileURL: URL

    init() {
        let name = String(describing: Model.self)
        self.manager = FileManager.default
        let folderURLs = manager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
    }

    func saveToDisk(_ data: Data) {
        do {
            try data.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadFromDisk() throws -> [Model] {
        let data = try Data(contentsOf: fileURL)
        let games = try JSONDecoder().decode([Model].self, from: data)
        return games
    }
}
