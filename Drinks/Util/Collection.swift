import Foundation

extension Collection {

    /// Optional access to the collection.
    /// - Parameter index: Index to be accessed.
    /// - Returns: The element at the index if it's valid and nil if out of bounds.
    func get(at index: Index) -> Element? {
        if self.indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
