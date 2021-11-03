import Foundation

class PokemonsViewModel {
    
    private var updateCallback: ((Error?) -> Void)?
    
    var items = [Item]()
    private var page: String? = "https://pokeapi.co/api/v2/pokemon?limit=30&offset=0"
    private var cache: [IndexPath: Data] = [:]
    
    func fetchPokemons() {
        guard let next = page, let nextURL = URL(string: next) else { return }
        let itemsURL = PokemonAPIURL.items(nextURL)

        PokemonService<Response>.fetch(apiURL: itemsURL) { result in
            switch result {
            case .success(let pokemonsResponse):
                self.items = pokemonsResponse.results
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
        guard let detailsURL = URL(string: items[indexPath.row].url) else { return }
        let detailsAPIURL = PokemonAPIURL.details(detailsURL)
        
        PokemonService<DetailsResponse>.fetch(apiURL: detailsAPIURL) { result in
            switch result {
            case .success(let detailsResponse):
                self.handleSuccessResult(detailsResponse, at: indexPath, completion)
            case .failure(let error):
                self.updateCallback?(error)
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
            }
            
        }
    }
    
    func subscribe(updateCallback: @escaping (Error?) -> Void) {
        self.updateCallback = updateCallback
    }
}
