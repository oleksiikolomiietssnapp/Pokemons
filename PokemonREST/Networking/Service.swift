//
//  PokemonsService.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

class Service {
    
    static func fetch<T: Decodable>(urlString: String, completion: @escaping (Result<T, APPError>) -> Void) {

        // MARK: - URLRequest
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)

        // MARK: - Configure session
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpShouldSetCookies = false
        let session = URLSession(configuration: sessionConfiguration)

        let task = session.dataTask(with: request) { data, response, error in
            // MARK: - Handling Error:
            if let error = error {

                DispatchQueue.main.async {
                    completion(.failure(.server(error)))
                }
                return
            }

            // MARK: - Handling Response:
            if let httpResponse = response as? HTTPURLResponse, 300...500 ~= httpResponse.statusCode {

                DispatchQueue.main.async {
                    completion(.failure(.statusCode((httpResponse.statusCode))))
                }
                return
            }

            // MARK: - Handling Data:
            guard let data = data else {

                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            do {
                // MARK: - Parsing Data:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {

                // MARK: - Decoder Error:
                DispatchQueue.main.async {
                    completion(.failure(APPError(parsingError: error)))
                }
            }
        }
        task.resume()
    }
    
}
