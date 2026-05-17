import Foundation

protocol RelationshipRepositoryProtocol {
    func getRelationship(for traineeId: String) async throws -> Relationship?
    func getTrainees(for trainerId: String) async throws -> [Relationship]
    func updateRelationshipStatus(id: String, status: RelationshipStatus) async throws
}
