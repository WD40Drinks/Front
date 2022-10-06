import UIKit

protocol ImageHandler {
    init(name: String)
    func getImage() async -> UIImage?
}
