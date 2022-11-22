import Foundation

class Network {
    enum NetworkError: Error {
        case badURL, badResponse
    }

    static let shared: Network = .init()

    private let domain: String

    private init() {
        self.domain = "https://caneco-drinks.herokuapp.com"
    }

    func load(_ resourcePath: String) async throws -> Data {
        guard let url = URL(string: "\(domain)/\(resourcePath)") else {
            throw Self.NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw Self.NetworkError.badResponse
        }

        return data
    }
}
