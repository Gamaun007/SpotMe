import Foundation

enum AuthError: LocalizedError {
    case notAuthenticated
    case invalidCredentials
    case tokenExpired
    case signOutFailed(Error)

    var errorDescription: String? {
        switch self {
        case .notAuthenticated: return "You must be signed in to continue."
        case .invalidCredentials: return "Incorrect email or password."
        case .tokenExpired: return "Your session has expired. Please sign in again."
        case .signOutFailed(let error): return "Sign out failed: \(error.localizedDescription)"
        }
    }
}

enum NetworkError: LocalizedError {
    case offline
    case timeout

    var errorDescription: String? {
        switch self {
        case .offline: return "You're offline. Changes will sync when you reconnect."
        case .timeout: return "Request timed out. Please try again."
        }
    }
}

enum DataError: LocalizedError {
    case notFound
    case decodingFailed
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .notFound: return "The requested data could not be found."
        case .decodingFailed: return "Failed to read data. Please try again."
        case .encodingFailed: return "Failed to save data. Please try again."
        }
    }
}

enum PermissionError: LocalizedError {
    case accessDenied
    case relationshipRequired

    var errorDescription: String? {
        switch self {
        case .accessDenied: return "You don't have permission to perform this action."
        case .relationshipRequired: return "A trainer–trainee relationship is required."
        }
    }
}
