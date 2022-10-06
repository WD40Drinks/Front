import UIKit

struct MockImageHandler: ImageHandler {
    let name: String

    init(name: String) {
        self.name = name
    }

    func getImage() async -> UIImage? {
        guard let image = UIImage(named: name) else {
            print("DEBUG: could not find mocked image with name \(name)")
            return nil
        }

        return image
    }
}
