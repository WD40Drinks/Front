import Foundation

extension UserDefaults {
    func append(_ value: Any, forKey key: String) {
        guard var array = self.array(forKey: key) else {
            self.set([value], forKey: key)
            return
        }
        array.append(value)
        self.setValue(array, forKey: key)
    }

    func removeAll(where shouldBeRemoved: (Any) -> Bool, forKey key: String) {
        guard var array = self.array(forKey: key) else {
            print("DEBUG: Could not found array for key \(key)")
            return
        }
        array.removeAll(where: shouldBeRemoved)
        self.set(array, forKey: key)
    }
}
