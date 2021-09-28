//
//  PokemonResponse.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let pokemons: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case count, next, previous
        case pokemons = "results"
    }
}

struct Pokemon: Decodable {
    let name: String
    let url: String
    var details: PokemonDetailsResponse? = nil
}


struct PokemonDetailsResponse: Decodable {
    let sprites: Sprites
    let name: String
    
    var spritesCount: Int {
        return sprites.all.count
    }
}
