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
    var pokemonsCount: Int = 0
    private var isReversed: Bool = false
    
    func toggleReverse() {
        isReversed.toggle()
        
        pokemons.reverse()
        
        updateCallback?(nil)

//        pokemons.removeAll()
//        cache.removeAll()
        
//        next = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
//        previus = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=\(pokemonsCount-100)"
        
//        fetchPokemons()
    }
    
    var next: String? = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
    lazy var previus: String? = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=\(pokemonsCount-100)"
    
    private var cache: [String: Data] = [:]
    private var cancellable: Set<AnyCancellable> = []
    
    func fetchPokemons() {
        if isReversed, previus == nil{
            return
        } else if !isReversed, next == nil {
            return
        }
        
        PokemonsService.fetchPokemons(urlString: isReversed ? previus : next) { result in
            switch result {
            case .success(let pokemonsResponse):
                if self.isReversed{
                    self.pokemons.append(contentsOf: pokemonsResponse.pokemons.reversed())
                    self.previus = pokemonsResponse.previous
                } else {
                    self.pokemons.append(contentsOf: pokemonsResponse.pokemons)
                    self.next = pokemonsResponse.next
                }
                
                self.pokemonsCount = pokemonsResponse.count
                
                self.updateCallback?(nil)
            case .failure(let error):
                self.updateCallback?(error)
            }
        }
    }
    
    func fetchPokemonImage(at indexPath: IndexPath, completion: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .userInteractive).sync {
            let name = pokemons[indexPath.row].name
            if let cachedData = cache[name] {
                completion(cachedData)
            } else {
                fetchPokemonDetails(at: indexPath, completion)
            }
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
        DispatchQueue.global(qos: .userInteractive).async(flags: .barrier) { [weak self] in
            guard let self = self,
                  let frontDefault = pokemonDetailsResponse.sprites.frontDefault,
                  let url = URL(string: frontDefault)
            else { return }
            
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    let name = self.pokemons[indexPath.row].name
                    self.cache[name] = data
                    completion(data)
                }
            } catch {
                self.updateCallback?(error)
                print(error.localizedDescription)
            }
            
        }
    }
    
    func subscribe(updateCallback: @escaping (Error?) -> Void) {
        self.updateCallback = updateCallback
    }
}
