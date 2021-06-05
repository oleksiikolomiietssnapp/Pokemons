//
//  PokemonsViewModel.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

class PokemonsViewModel {
    
    private var updateCallback: ((Error?) -> Void)?
    
    var pokemons = [Pokemon]()
    private var cache = [IndexPath: Data]()
    
    func getAllPokemons() {
        PokemonsService.fetchPokemons { result in
            switch result {
            case .success(let pokemonsResponse):
                self.pokemons = pokemonsResponse.pokemons
                self.updateCallback?(nil)
            case .failure(let error):
                self.updateCallback?(error)
            }
        }
    }
    
    func fetchPokemonImage(at indexPath: IndexPath, completion: @escaping (Data) -> Void) {
        if let cachedData = cache[indexPath] {
            completion(cachedData)
        } else {
            fetchPokemonDetails(at: indexPath, completion)
        }
    }
    
    private func fetchPokemonDetails(at indexPath: IndexPath, _ completion: @escaping (Data) -> Void) {
        PokemonsService.fetchPokemonDetails(urlString: self.pokemons[indexPath.row].url) { result in
            switch result {
            case .success(let pokemonDetailsResponse):
                self.handleSuccessResult(pokemonDetailsResponse, at: indexPath, completion)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleSuccessResult(_ pokemonDetailsResponse: PokemonDetailsResponse,
                                     at indexPath: IndexPath,
                                     _ completion: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: pokemonDetailsResponse.sprites.frontDefault),
                  let data = try? Data(contentsOf: url)
            else { return }
            
            self.cache[indexPath] = data
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    func subscribe(updateCallback: @escaping (Error?) -> Void) {
        self.updateCallback = updateCallback
    }
}
