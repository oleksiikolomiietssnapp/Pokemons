//
//  PokemonsViewController.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import UIKit

class PokemonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: PokemonsViewModel?
    
    private var activityIndicators = [IndexPath: UIActivityIndicatorView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel = PokemonsViewModel()
        
        viewModel?.subscribe { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel?.fetchPokemons()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.pokemons.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        guard let pokemonViewModel = viewModel else {
            return cell
        }
        let pokemon = pokemonViewModel.pokemons[indexPath.row]
        cell.textLabel?.text = pokemon.name
        
        cell.imageView?.image = UIImage(named: "empty")
        cell.imageView?.backgroundColor = .clear
        cell.selectionStyle = .blue
        guard let imageView = cell.imageView else {
            return cell
        }
        
        // Spinner
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView?.addSubview(activityIndicator)
        cell.addConstraints([
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 24),
            activityIndicator.widthAnchor.constraint(equalToConstant: 24)
        ])
        activityIndicator.startAnimating()
        activityIndicators[indexPath] = activityIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: Look why spinner iis there for 'kommo-0-totem' 
        viewModel?.fetchPokemonImage(at: indexPath) { data in
            DispatchQueue.main.async {
                self.activityIndicators[indexPath]?.removeFromSuperview()
                self.activityIndicators[indexPath] = nil
                cell.imageView?.image = UIImage(data: data)
            }
        }
        
        if ((indexPath.row + 1) == viewModel?.pokemons.count) {
            viewModel?.fetchPokemons()
        }
    }
    
}
