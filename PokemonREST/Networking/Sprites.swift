//
//  Sprites.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 28.09.2021.
//

import Foundation

struct Sprites: Decodable {
    var all: [String] = []
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let strings: [String?] = [
            try container.decodeIfPresent(String.self, forKey: .frontDefault),
            try container.decodeIfPresent(String.self, forKey: .frontFemale),
            try container.decodeIfPresent(String.self, forKey: .frontShiny),
            try container.decodeIfPresent(String.self, forKey: .frontShinyFemale),
            try container.decodeIfPresent(String.self, forKey: .backDefault),
            try container.decodeIfPresent(String.self, forKey: .backFemale),
            try container.decodeIfPresent(String.self, forKey: .backShiny),
            try container.decodeIfPresent(String.self, forKey: .backShinyFemale)
        ]
            
        all = strings.compactMap({ $0 })
        
        
        if let otherContainer = try? container.nestedContainer(keyedBy: OtherCodingKeys.self, forKey: .other) {
            let officialArtwork = try otherContainer.decode(Sprite.self, forKey: .officialArtwork)
            let dreamWorld = try otherContainer.decode(Sprite.self, forKey: .dreamWorld)
            let others = officialArtwork.urlString + dreamWorld.urlString
            
            all.append(contentsOf: others)
        }
        
        if let versionsContainer = try? container.decodeIfPresent(SpriteOtherVersions.self, forKey: .versions) {
            all.append(contentsOf: versionsContainer.sprites)
        }
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
        case other
        case versions
    }
    
    enum OtherCodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
        case dreamWorld  = "dream_world"
    }
    
    
}

struct Sprite: Decodable {
    let frontDefault: String?
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    
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
    
    var urlString: [String] {
        return [
            frontDefault, frontFemale, frontShiny, frontShinyFemale,
            backDefault, backFemale, backShiny, backShinyFemale
        ].compactMap({$0})
    }
}

struct SpriteOtherVersions: Decodable {
    var sprites: [String] = []
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let iContainer = try container.nestedContainer(keyedBy: iCodingKeys.self, forKey: .i)
        let redAndBlue = try iContainer.decode(Sprite.self, forKey: .redAndBlue)
        let yellow = try iContainer.decode(Sprite.self, forKey: .yellow)
        let iSprites = redAndBlue.urlString + yellow.urlString
        
        let iiContainer = try container.nestedContainer(keyedBy: iiCodingKeys.self, forKey: .ii)
        let crystal = try iiContainer.decode(Sprite.self, forKey: .crystal)
        let gold = try iiContainer.decode(Sprite.self, forKey: .gold)
        let silver = try iiContainer.decode(Sprite.self, forKey: .silver)
        let iiSprites = crystal.urlString + gold.urlString + silver.urlString
        
        let iiiContainer = try container.nestedContainer(keyedBy: iiiCodingKeys.self, forKey: .iii)
        let emerald = try iiiContainer.decode(Sprite.self, forKey: .emerald)
        let fire = try iiiContainer.decode(Sprite.self, forKey: .fireredLeafgreen)
        let ruby = try iiiContainer.decode(Sprite.self, forKey: .rubySapphire)
        let iiiSprites = emerald.urlString + fire.urlString + ruby.urlString
        
        let ivContainer = try container.nestedContainer(keyedBy: ivCodingKeys.self, forKey: .iv)
        let diamondAndPearl = try ivContainer.decode(Sprite.self, forKey: .diamondAndPearl)
        let heartgoldAndSoulsilver = try ivContainer.decode(Sprite.self, forKey: .heartgoldAndSoulsilver)
        let platinum = try ivContainer.decode(Sprite.self, forKey: .platinum)
        let ivSprites = diamondAndPearl.urlString + heartgoldAndSoulsilver.urlString + platinum.urlString
        
        let vContainer = try container.nestedContainer(keyedBy: vCodingKeys.self, forKey: .v)
        let blackWhite = try vContainer.decode(Sprite.self, forKey: .blackWhite)
        let vSprites = blackWhite.urlString
        
        let viContainer = try container.nestedContainer(keyedBy: viCodingKeys.self, forKey: .vi)
        let omegarubyAndAlphasapphire = try viContainer.decode(Sprite.self, forKey: .omegarubyAndAlphasapphire)
        let xAndY = try viContainer.decode(Sprite.self, forKey: .xAndY)
        let viSprites = omegarubyAndAlphasapphire.urlString + xAndY.urlString
        
        let viiContainer = try container.nestedContainer(keyedBy: viiCodingKeys.self, forKey: .vii)
        let viiIcons = try viiContainer.decode(Sprite.self, forKey: .icons)
        let ultrasunUltramoon = try viiContainer.decode(Sprite.self, forKey: .ultrasunUltramoon)
        let viiSprites = viiIcons.urlString + ultrasunUltramoon.urlString
        
        let viiiContainer = try container.nestedContainer(keyedBy: viiiCodingKeys.self, forKey: .viii)
        let viiiIcons = try viiiContainer.decode(Sprite.self, forKey: .icons)
        let viiiSprites = viiiIcons.urlString
        
        sprites = iSprites + iiSprites + iiiSprites + ivSprites + vSprites + viSprites + viiSprites + viiiSprites
    }
    
    enum CodingKeys: String, CodingKey {
        case i = "generation-i"
        case ii = "generation-ii"
        case iii = "generation-iii"
        case iv = "generation-iv"
        case v = "generation-v"
        case vi = "generation-vi"
        case vii = "generation-vii"
        case viii = "generation-viii"
    }
    
    enum iCodingKeys: String, CodingKey {
        case redAndBlue = "red-blue"
        case yellow
    }
    
    enum iiCodingKeys: String, CodingKey {
        case crystal
        case gold
        case silver
    }
    
    enum iiiCodingKeys: String, CodingKey {
        case emerald
        case fireredLeafgreen = "firered-leafgreen"
        case rubySapphire = "ruby-sapphire"
    }
    
    enum ivCodingKeys: String, CodingKey {
        case diamondAndPearl = "diamond-pearl"
        case heartgoldAndSoulsilver = "heartgold-soulsilver"
        case platinum
    }
    
    enum vCodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
    
    enum viCodingKeys: String, CodingKey {
        case xAndY = "x-y"
        case omegarubyAndAlphasapphire = "omegaruby-alphasapphire"
    }
    
    enum viiCodingKeys: String, CodingKey {
        case ultrasunUltramoon = "ultra-sun-ultra-moon"
        case icons
    }
    
    enum viiiCodingKeys: String, CodingKey {
        case icons
    }
}
