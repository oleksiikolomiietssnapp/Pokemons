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
            DispatchQueue.global().async {
                let pokemon = self.pokemons[indexPath.row]
                let id = pokemon.url
                    .components(separatedBy: "/")
                    .dropLast()
                    .last!
                let string = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" + id + ".png"
                guard let url = URL(string: string),
                      let data = try? Data(contentsOf: url)
                else { return }
                
                self.cache[indexPath] = data
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
    
    func subscribe(updateCallback: @escaping (Error?) -> Void) {
        self.updateCallback = updateCallback
    }
}
