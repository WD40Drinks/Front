import UIKit

struct MockImageHandler: ImageHandler {
    func getImage(name: String) async -> UIImage? {
        guard let image = UIImage(named: name) else {
            print("DEBUG: could not find mocked image with name \(name)")
            return nil
        }

        return image
    }
}
