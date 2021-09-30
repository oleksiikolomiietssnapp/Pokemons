//
//  PokemonResponse.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let pokemons: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case count, next, previous
        case pokemons = "results"
    }
}

struct Pokemon: Codable {
    let name: String
    let url: String
}


struct PokemonDetailsResponse: Codable {
    let sprites: Sprites
    let weight: Int
    let height: Int
    let base_experience: Int
    
    // Add CodingKeys to avoid snake case
}

struct Sprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
