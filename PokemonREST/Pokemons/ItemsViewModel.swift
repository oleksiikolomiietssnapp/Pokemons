//
//  ItemsViewModel.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

class ItemsViewModel {
    
    private var updateCallback: ((Error?) -> Void)?
    
    var items = [Item]()
    var next: String? = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
    
    private var cache: [IndexPath: Data] = [:]
    
    func fetchItems() {
        guard let next = next else { return }

        Service.fetch(urlString: next) { (result: Result<Response, APPError>) in
            switch result {
            case .success(let pokemonsResponse):
                self.next = pokemonsResponse.next
                if pokemonsResponse.previous == nil {
                    self.items = pokemonsResponse.results
                } else {
                    self.items.append(contentsOf: pokemonsResponse.results)
                }
                self.updateCallback?(nil)
            case .failure(let error):
                self.updateCallback?(error)
            }
        }
    }
    
    func fetchPokemonImage(at indexPath: IndexPath, completion: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .userInteractive).sync {
            if let cachedData = cache[indexPath] {
                completion(cachedData)
            } else {
                fetchDetails(at: indexPath, completion)
            }
        }
    }
    
    private func fetchDetails(at indexPath: IndexPath, _ completion: @escaping (Data) -> Void) {
        Service.fetch(urlString: self.items[indexPath.row].url) { (result: Result<DetailsResponse, APPError>) in
            switch result {
            case .success(let detailsResponse):
                self.handleSuccessResult(detailsResponse, at: indexPath, completion)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleSuccessResult(_ detailsResponse: DetailsResponse,
                                     at indexPath: IndexPath,
                                     _ completion: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async(flags: .barrier) { [weak self] in
            guard let self = self,
                  let frontDefault = detailsResponse.details.frontDefault,
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
