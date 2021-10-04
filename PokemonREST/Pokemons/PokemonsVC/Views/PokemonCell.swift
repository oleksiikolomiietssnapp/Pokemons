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
    
    var imageURL: String = String(){
        didSet{
            pokemonImage.set(with: URL(string: imageURL)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(pokemon: Pokemon){
        pokemonName.text = pokemon.name
        }
}
