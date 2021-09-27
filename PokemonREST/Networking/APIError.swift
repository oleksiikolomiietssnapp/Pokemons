//
//  APIError.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

enum APIError: Error, LocalizedError {
    case server(Error)
    case statusCode(Int)
    case noData
    case wrongType(String)
    
    var errorDescription: String? {
        switch self {
        case .server(let error):
            return error.localizedDescription
        case .statusCode(let code):
            return "Status code: \(code)"
        case .noData:
            return "Data is nil"
        case .wrongType(let typeName):
            return "Response type is not \(typeName)"
        }
    }
}
