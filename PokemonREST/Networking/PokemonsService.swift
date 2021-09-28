//
//  PokemonsService.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

typealias ServiceResult<T> = Result<T, APIError>

class PokemonsService {
    
    static func fetchPokemons(urlString: String? = nil) async throws -> PokemonResponse {
        let urlStringFOrREquest = urlString ?? "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
        guard let url = URL(string: urlStringFOrREquest) else {
            throw APIError.noData
        }
        let request = URLRequest(url: url)
        let data = try await NetworkingPerfomer.performFetch(with: request)
        let pokemons = try JSONDecoder().decode(PokemonResponse.self, from: data)
        
        return pokemons
    }
    
    static func fetchPokemonDetails(urlString: String,
                                    completion: @escaping (ServiceResult<PokemonDetailsResponse>) -> Void) {
        let request = URLRequest(url: URL(string: urlString)!)
        
        NetworkingPerfomer.performFetch(request: request, completion: completion)
    }
}
