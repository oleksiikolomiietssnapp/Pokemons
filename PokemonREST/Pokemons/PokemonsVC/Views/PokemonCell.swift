//
//  PokemonCell.swift
//  PokemonREST
//
//  Created by Ann on 01.10.2021.
//

import UIKit

class PokemonCell: UITableViewCell {
    private var viewModel: PokemonsViewModel?
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonActivity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(pokemon: Pokemon){
        pokemonImage.set(with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/819.png")!)
        }
}
