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
    
    static func cFetchPokemons(urlString: String) -> AnyPublisher<PokemonResponse, Error> {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        let request = URLRequest(url: url)
        
        return NetworkingPerfomer.performCombineFetch(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
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
