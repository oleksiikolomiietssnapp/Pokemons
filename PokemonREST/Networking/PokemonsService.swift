//
//  PokemonsService.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

typealias ServiceResult<T> = Result<T, APIError>

class PokemonsService {
    
    static func fetchPokemons(urlString: String? = nil) async throws -> ServiceResult<PokemonResponse> {
        let urlStringFOrREquest = urlString ?? "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
        guard let url = URL(string: urlStringFOrREquest) else {
            return .failure(.noData)
        }
        let request = URLRequest(url: url)
        
        let (data, error) = try await URLSession.shared.data(for: request)
        guard let pokemons = try? JSONDecoder().decode(PokemonResponse.self, from: data) else {
            return .failure(APIError.noData)
        }
        
        return .success(pokemons)
    }
    
    static func fetchPokemonDetails(urlString: String,
                                    completion: @escaping (ServiceResult<PokemonDetailsResponse>) -> Void) {
        let request = URLRequest(url: URL(string: urlString)!)
        
        NetworkingPerfomer.performFetch(request: request, completion: completion)
    }
}
