//
//  NetworkingPerfomer.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

class NetworkingPerfomer {
    
    static func performFetch(with request: URLRequest) async throws ->  Data{
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse,
           !(200...299).contains(response.statusCode){
           throw APIError.statusCode(response.statusCode)
        }
        return data
    }
    
    static func performFetch<T: Decodable>(request: URLRequest, completion: @escaping (ServiceResult<T>) -> Void) {
        
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
                    let decodedPokemons = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedPokemons))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.wrongType(String(describing: T.self))))
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print(json ?? "no json")
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
