import Foundation

enum APIError: Error, LocalizedError {
    case badResponse
    case noData
    case decodingError(reason: String)
    case serverError(Error)

    var errorDescription: String? {
        switch self {
        case .badResponse:
            return "Bad response"
        case .noData:
            return "No data found"
        case .decodingError(let reason):
            return reason
        case .serverError(let error):
            return error.localizedDescription
        }
    }

    init(decodingError: Error) {
        guard let decodingError = decodingError as? DecodingError else {
            self = .decodingError(reason: decodingError.localizedDescription)
            return
        }

        var errorToReport = decodingError.localizedDescription
        switch decodingError {
        case .dataCorrupted(let context):
            errorToReport = "\(context.debugDescription) - (\(context.details))"
        case .keyNotFound(let key, let context):
            errorToReport = "\(context.debugDescription) (key: \(key), \(context.details))"
        case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
            errorToReport = "\(context.debugDescription) (type: \(type), \(context.details))"
        @unknown default:
            break
        }
        self = .decodingError(reason: errorToReport)
    }
}

extension DecodingError.Context {
    var details: String {
        underlyingError?.localizedDescription
        ?? codingPath
            .map { $0.stringValue }
            .joined(separator: ".")
    }
}
