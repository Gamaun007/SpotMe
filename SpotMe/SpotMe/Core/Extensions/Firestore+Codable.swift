import FirebaseFirestore

extension DocumentSnapshot {
    func decode<T: Decodable>(as type: T.Type = T.self) throws -> T {
        try data(as: type)
    }
}

extension CollectionReference {
    func addDocument<T: Encodable>(from value: T) throws {
        _ = try addDocument(from: value)
    }
}
