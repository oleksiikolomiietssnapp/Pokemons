//
//  PokemonsViewController.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 29.05.2021.
//

import UIKit

class PokemonsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PokemonsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
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
        
        return cell
    }
    
}
