//
//  PokemonCell.swift
//  PokemonREST
//
//  Created by Ann on 29.09.2021.
//

import UIKit

class PokemonCell: UITableViewCell {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pokemonName: UILabel!
    
    var isImageLoading: Bool = false{
        didSet{
            if isImageLoading{
                pokemonIndicator.startAnimating()
            } else {
                pokemonIndicator.stopAnimating()
            }
            pokemonIndicator.isHidden = !isImageLoading
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
    }
    
    override func prepareForReuse() {
        prepareCell()
    }
    
    func prepareCell(){
        pokemonImage.image = nil
        pokemonIndicator.isHidden = true
        pokemonName.text = "Loading.."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
