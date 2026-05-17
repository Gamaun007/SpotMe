import Foundation

protocol ProgramRepositoryProtocol {
    func getPrograms(for trainerId: String) async throws -> [Program]
    func getProgram(id: String) async throws -> Program
    func createProgram(_ program: Program) async throws
    func updateProgram(_ program: Program) async throws
    func deleteProgram(id: String) async throws
}
