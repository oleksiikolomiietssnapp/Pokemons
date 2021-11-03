import Foundation

struct PokemonItem: Codable {
    let name: String
    let url: String
}

struct PokemonsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonItem]
}

struct PokemonDetailsResponse: Codable {

    struct Details: Codable {
        let frontDefault: String?
    }

    let details: Details

    enum CodingKeys: String, CodingKey {
        case details = "sprites"
    }
}


