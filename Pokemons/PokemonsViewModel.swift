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
    
    func subscribe(updateCallback: @escaping (Error?) -> Void) {
        self.updateCallback = updateCallback
    }
}
