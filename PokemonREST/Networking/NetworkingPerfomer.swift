//
//  NetworkingPerfomer.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

class NetworkingPerfomer {
    
    static func performFetch<T: Decodable>(using urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.brokenURL
        }
        let request = URLRequest(url: url)
        let data = try await performFetch(with: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static private func performFetch(with request: URLRequest) async throws ->  Data {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse,
           !(200...299).contains(response.statusCode){
           throw APIError.statusCode(response.statusCode)
        }
        return data
    }
}
