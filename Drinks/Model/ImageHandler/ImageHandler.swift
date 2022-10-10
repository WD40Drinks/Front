import UIKit

protocol ImageHandler {
    init()
    func getImage(name: String) async -> UIImage?
}
