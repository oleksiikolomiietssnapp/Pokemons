//
//  PokemonsViewController.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import UIKit

class PokemonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PokemonsViewModel?
    
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
            
            self.tableView.reloadData()
        }
        viewModel?.getAllPokemons()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel?.fetchPokemonImage(at: indexPath) { data in
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data)
            }
        }
    }
    
}
