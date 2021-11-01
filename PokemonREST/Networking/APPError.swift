//
//  APPError.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

enum APPError: Error, LocalizedError {
    case server(Error)
    case statusCode(Int)
    case noData
    case parserError(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .server(let error):
            return error.localizedDescription
        case .statusCode(let code):
            return "Status code: \(code)"
        case .noData:
            return "Data is nil"
        case .parserError(let reason):
            return reason
        }
    }

    init(parsingError: Error) {
        guard let decodingError = parsingError as? DecodingError else {
            self = .parserError(reason: parsingError.localizedDescription)
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
        self = .parserError(reason: errorToReport)
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
