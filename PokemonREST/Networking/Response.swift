//
//  Response.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import Foundation

struct Item: Codable {
    let name: String
    let url: String
}

struct Response: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Item]
}

struct DetailsResponse: Codable {

    struct Details: Codable {
        let frontDefault: String?
    }

    let details: Details

    enum CodingKeys: String, CodingKey {
        case details = "sprites"
    }
}


