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
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareViewModel()
    }
    
    func prepareView(){
        title = "Pokemons"

        tableView.dataSource = self
        tableView.delegate = self
        viewModel = PokemonsViewModel()
    }
    
    func prepareViewModel(){
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "PokemonDetails", bundle: nil)
            guard let details = storyboard
                    .instantiateViewController(withIdentifier: "PokemonDetailsViewController")
                    as? PokemonDetailsViewController
            else { return }
    
            let viewModel = PokemonDetailsViewModel(details: viewModel!.pokemons[indexPath.row].details!)
            details.viewModel = viewModel
    
            navigationController?.pushViewController(details, animated: true)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.pokemons.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                if ((indexPath.row + 1) == viewModel?.pokemons.count) {
                    viewModel?.fetchPokemons()
                }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as! PokemonCell
        guard let pokemonViewModel = viewModel else {
                    return cell
                }
                let pokemon = pokemonViewModel.pokemons[indexPath.row]
                cell.pokemonName?.text = "\(indexPath.row). " + pokemon.name
        
                cell.pokemonImage?.image = UIImage(named: "empty")
                cell.pokemonImage?.backgroundColor = .clear
//                cell.selectionStyle = .blue
        guard cell.pokemonImage != nil else {
                    return cell
                }
        cell.isImageLoading = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PokemonCell else {return}
            // TODO: Look why spinner is there for 'kommo-0-totem'
            if let cachedData = viewModel?.cache[indexPath] {
                cell.pokemonImage?.image = UIImage(data: cachedData)
                cell.isImageLoading = false
            } else {
                Task {
                    let currentIndexPath = indexPath
                    do {
                        let imageData = try await viewModel?.fetchPokemonDetails(at: currentIndexPath)
                        //resolve problem with image glitch
                        guard let indexes = tableView.indexPathsForVisibleRows, indexes.contains(indexPath) else {return}
                        DispatchQueue.main.async {
                            cell.pokemonImage?.image = UIImage(data: imageData!)
                            cell.isImageLoading = false
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
}
