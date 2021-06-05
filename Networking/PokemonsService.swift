//
//  PokemonsService.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

class PokemonsService {
    typealias ServiceResult<T> = Result<T, APIError>
    
    static func fetchPokemons(completion: @escaping (ServiceResult<PokemonResponse>) -> Void) {
        let request = URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200")!)
        
        NetworkingPerfomer.performFetch(request: request, completion: completion)
    }
    
    static func fetchPokemonDetails(urlString: String,
                                    completion: @escaping (ServiceResult<PokemonDetailsResponse>) -> Void) {
        let request = URLRequest(url: URL(string: urlString)!)
        
        NetworkingPerfomer.performFetch(request: request, completion: completion)
    }
}
