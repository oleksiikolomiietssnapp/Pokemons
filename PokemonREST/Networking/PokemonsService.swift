//
//  PokemonsService.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation
import Combine

typealias ServiceResult<T> = Result<T, APIError>

class PokemonsService {
    
    let pokemonsPublisher = PassthroughSubject<PokemonResponse, APIError>()
    
    func fetchPokemons (urlString: String){
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else {return}
            if let error = error, data != nil {
                self.pokemonsPublisher.send(completion: .failure(.noData))
                return
            }
            do {
                let response = try JSONDecoder().decode(PokemonResponse.self, from: data!)
                self.pokemonsPublisher.send(response)
                if  response.next == nil {
                    self.pokemonsPublisher.send(completion: .finished)
                }
            } catch {
                self.pokemonsPublisher.send(completion: .failure(.noData))
            }
        }.resume()
//        return NetworkingPerfomer.performCombineFetch(request: request)
//            .map(\.value)
//            .mapError( { APIError.server($0) })
//            .eraseToAnyPublisher()
    }
    
//    static func combineFetchPokemonDetails(urlString: String) -> AnyPublisher<Data, APIError> {
//        let details: AnyPublisher<PokemonDetailsResponse, APIError> = getAnyPublisher(urlString: urlString)
//        
//        return details.flatMap { response in
//            let subscriber = AnySubscriber(DispatchQueue.global(qos: .userInteractive))
//            guard let self = self,
//                  let frontDefault = response.sprites.frontDefault,
//                  let url = URL(string: frontDefault)
//            else {
//                subscriber.receive(
//                    completion: .failure(APIError.noData)
//                )
//                return
//            }
//            
//            do {
//                let data = try Data(contentsOf: url)
//                let mainSubscriber = AnySubscriber(DispatchQueue.main)
//                mainSubscriber.receive(data)
//                mainSubscriber.receive(completion: .finished)
//            } catch {
//                subscriber.receive(
//                    completion: .failure(APIError.server(error))
//                )
//            }
//            
//            //                }
//        }
//        .mapError( { APIError.server($0) })
//        .eraseToAnyPublisher()
//        
//    }
    
    static func fetchPokemons(urlString: String? = nil, completion: @escaping (ServiceResult<PokemonResponse>) -> Void) {
        let urlStringFOrREquest = urlString ?? "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
        guard let url = URL(string: urlStringFOrREquest) else {
            return
        }
        let request = URLRequest(url: url)
        
        NetworkingPerfomer.performFetch(request: request, completion: completion)
    }
    
    static func fetchPokemonDetails(urlString: String,
                                    completion: @escaping (ServiceResult<PokemonDetailsResponse>) -> Void) {
        let request = URLRequest(url: URL(string: urlString)!)
        
        NetworkingPerfomer.performFetch(request: request, completion: completion)
    }
}
