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
        return sprites.front.count + sprites.back.count
    }
}

struct Sprites: Decodable {
    let front: Sprite
    let back: Sprite
    
    struct Sprite: Codable {
        let `default`: String?
        let female: String?
        let shiny: String?
        let shinyFemale: String?
        
        var sprites: [String] {
            return [`default`, female, shiny, shinyFemale]
                .compactMap({ $0})
        }
        
        var count: Int {
            return [`default`, female, shiny, shinyFemale]
                .compactMap({ $0})
                .count
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        front = Sprite(
            default: try container.decodeIfPresent(String.self, forKey: .frontDefault),
            female: try container.decodeIfPresent(String.self, forKey: .frontFemale),
            shiny: try container.decodeIfPresent(String.self, forKey: .frontShiny),
            shinyFemale: try container.decodeIfPresent(String.self, forKey: .frontShinyFemale)
        )
        back = Sprite(
            default: try container.decodeIfPresent(String.self, forKey: .backDefault),
            female: try container.decodeIfPresent(String.self, forKey: .backFemale),
            shiny: try container.decodeIfPresent(String.self, forKey: .backShiny),
            shinyFemale: try container.decodeIfPresent(String.self, forKey: .backShinyFemale)
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
    }
}
