import Foundation

class Persistence<Model: Codable> {
    private let manager: FileManager
    private let fileURL: URL

    init(_ type: Model.Type) {
        let name = String(describing: type)
        self.manager = FileManager.default
        let folderURLs = manager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
    }

    func saveToDisk(_ data: Data) {
        do {
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }

    func loadFromDisk() -> [Model]? {
        if manager.fileExists(atPath: fileURL.path()) {
            if
                let data = try? Data(contentsOf: fileURL),
                let games = try? JSONDecoder().decode([Model].self, from: data)
            {
                return games
            }
        }

        print("DEBUG: Could not get model object from disk")
        return nil
    }
}
