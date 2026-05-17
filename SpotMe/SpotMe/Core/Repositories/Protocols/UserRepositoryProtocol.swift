import Foundation

protocol UserRepositoryProtocol {
    func getUser(id: String) async throws -> User
    func createUser(_ user: User) async throws
    func updateUser(_ user: User) async throws
}
