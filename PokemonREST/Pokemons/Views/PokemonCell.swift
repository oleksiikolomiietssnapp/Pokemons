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
    
    func set(pokemon: PokemonResponse){
        viewModel?.fetchPokemonImage(at: indexPath) { data in
            DispatchQueue.main.async {
                self.activityIndicators[indexPath]?.removeFromSuperview()
                self.activityIndicators[indexPath] = nil
                cell.imageView?.image = UIImage(data: data)
            }
        }

    }
//    guard let pokemonViewModel = viewModel else {
//            return PokemonCell
//        }
//        let pokemon = pokemonViewModel.pokemons[indexPath.row]
//        let stringNum = "\(indexPath.row)."
//        let stringWithName = "\(stringNum) \(pokemon.name)"
//        let attributedStringWithName = NSMutableAttributedString(string: stringWithName)
//        attributedStringWithName.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: 0, length: stringNum.count))
//        cell.textLabel?.attributedText = attributedStringWithName
//
//        cell.imageView?.image = UIImage(named: "empty")
//        cell.imageView?.backgroundColor = .clear
//        cell.selectionStyle = .blue
//        guard let imageView = cell.imageView else {
//            return cell
//        }
//
//        // Spinner
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.color = .systemGray
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        cell.imageView?.addSubview(activityIndicator)
//        cell.addConstraints([
//            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
//            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
//            activityIndicator.heightAnchor.constraint(equalToConstant: 24),
//            activityIndicator.widthAnchor.constraint(equalToConstant: 24)
//        ])
//        activityIndicator.startAnimating()
//    activityIndicators[indexPath] = activityIndicator
//    
//    return cell
}
