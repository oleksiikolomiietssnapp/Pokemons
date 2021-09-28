//
//  PokemonDetailsViewModel.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.09.2021.
//

import Foundation

class PokemonDetailsViewModel {
    
    let details: PokemonDetailsResponse
    private(set) var cache: [Data] = []
    private(set) var urls: [URL] = []
    
    init(details: PokemonDetailsResponse) {
        self.details = details
        
        cache = try! details.sprites.all
            .map { sprite in
                guard let url = URL(string: sprite)
                else { throw APIError.brokenURL }
                
                self.urls.append(url)
                return try Data(contentsOf: url)
            }
    }
}
