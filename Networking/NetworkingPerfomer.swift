//
//  NetworkingPerfomer.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

class NetworkingPerfomer {
    static func performFetch<S: Decodable>(request: URLRequest, completion: @escaping (Result<S, APIError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            // error
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.server(error)))
                }
                return
            }
            
            // response
            if let httpResponse = response as? HTTPURLResponse,
               (400...500).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(.failure(.statusCode(httpResponse.statusCode)))
                }
                return
            }
            
            // data
            if let data = data {
                
                do {
                    let decodedPokemons = try JSONDecoder().decode(S.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedPokemons))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.wrongType(String(describing: S.self))))
                        print(
                            try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        )
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
            }
        }
        .resume()
    }
}
