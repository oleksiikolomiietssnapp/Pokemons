//
//  PokemonsViewModel.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation
import Combine

class PokemonsViewModel {
    
    private var updateCallback: ((Error?) -> Void)?
    
    var pokemons = [Pokemon]()
    var next: String? = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
    
    private(set) var cache: [IndexPath: Data] = [:]
    private var cancellable: Set<AnyCancellable> = []
    
    func fetchPokemons() {
        guard let next = next else { return }
        
        Task {
            do {
                let pokemonsResponse: PokemonResponse = try await NetworkingPerfomer.performFetch(using: next)
                if pokemonsResponse.previous == nil {
                    self.pokemons = pokemonsResponse.pokemons
                } else {
                    self.pokemons.append(contentsOf: pokemonsResponse.pokemons)
                }
                
                self.next = pokemonsResponse.next
                
                self.updateCallback?(nil)
            } catch {
                self.updateCallback?(error)
            }
        }
    }
    
    func fetchPokemonDetails(at indexPath: IndexPath) async throws -> Data {
        let detailsURLString = self.pokemons[indexPath.row].url
        let details: PokemonDetailsResponse = try await NetworkingPerfomer.performFetch(using: detailsURLString)
        return try getImageData(for: details, at: indexPath)
    }
    
    private func getImageData(
        for pokemonDetailsResponse: PokemonDetailsResponse,
        at indexPath: IndexPath
    ) throws -> Data {
        
        guard let frontDefault = pokemonDetailsResponse.sprites.frontDefault,
              let url = URL(string: frontDefault)
        else { throw APIError.brokenURL }
        
        let data = try Data(contentsOf: url)
        self.cache[indexPath] = data
        
        return data
    }
    
    func subscribe(updateCallback: @escaping (Error?) -> Void) {
        self.updateCallback = updateCallback
    }
}
