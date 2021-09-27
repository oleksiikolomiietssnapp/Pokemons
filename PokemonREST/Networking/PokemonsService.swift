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
    
    static func getAnyPublisher<S: Decodable>(urlString: String) -> AnyPublisher<S, APIError> {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        let request = URLRequest(url: url)
        
        return NetworkingPerfomer.performCombineFetch(request: request)
            .map(\.value)
            .mapError( { APIError.server($0) })
            .eraseToAnyPublisher()
    }
    
    static func combineFetchPokemons(urlString: String) -> AnyPublisher<PokemonResponse, APIError> {
        return getAnyPublisher(urlString: urlString)
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
