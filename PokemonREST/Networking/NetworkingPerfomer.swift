//
//  NetworkingPerfomer.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation
import Combine

class NetworkingPerfomer {
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    static func performCombineFetch<S: Decodable>(request: URLRequest) -> AnyPublisher<Response<S>, Error> {
        
        let decoder = JSONDecoder()
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<S> in
                let value = try decoder.decode(S.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func performFetch<S: Decodable>(request: URLRequest, completion: @escaping (ServiceResult<S>) -> Void) {
        
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
