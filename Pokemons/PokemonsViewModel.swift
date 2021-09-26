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
    
    private var cache: [IndexPath: Data] = [:]
    private var cancellable: Set<AnyCancellable> = []
    
    func fetchPokemons() {
        guard let next = next else { return }
        
        PokemonsService.cFetchPokemons(urlString: next)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Done")
                    case .failure(let error):
                        self.updateCallback?(error)
                    }
                },
                receiveValue: {
                    if $0.previous == nil {
                        self.pokemons = $0.pokemons
                    } else {
                        self.pokemons.append(contentsOf: $0.pokemons)
                    }
                    self.next = $0.next
                    
                    // TODO: ??? Is it better to fire updateCallback in case .finished: ???
                    self.updateCallback?(nil)
                }
            )
            .store(in: &cancellable)

//        PokemonsService.fetchPokemons() { result in
//            switch result {
//            case .success(let pokemonsResponse):
//                self.pokemons = pokemonsResponse.pokemons
//                self.next = pokemonsResponse.next
//                self.updateCallback?(nil)
//            case .failure(let error):
//                self.updateCallback?(error)
//            }
//        }
    }
    
    func fetchPokemonImage(at indexPath: IndexPath, completion: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .userInteractive).sync {
            if let cachedData = cache[indexPath] {
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
                    self.cache[indexPath] = data
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
