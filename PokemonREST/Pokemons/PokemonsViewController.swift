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
        
        title = "Pokemons"
        
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
        let cell = UITableViewCell()
        
        guard let pokemonViewModel = viewModel else {
            return cell
        }
        let pokemon = pokemonViewModel.pokemons[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row). " + pokemon.name
        
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
        // TODO: Look why spinner is there for 'kommo-0-totem'
        if let cachedData = viewModel?.cache[indexPath] {
            cell.imageView?.image = UIImage(data: cachedData)
            self.activityIndicators[indexPath]?.removeFromSuperview()
            self.activityIndicators[indexPath] = nil
        } else {
            Task {
                let currentCell = cell
                let currentIndexPath = indexPath
                let imageData = try await viewModel?.fetchPokemonDetails(at: currentIndexPath)
                DispatchQueue.main.async {
                    currentCell.imageView?.image = UIImage(data: imageData!)
                    self.activityIndicators[currentIndexPath]?.removeFromSuperview()
                    self.activityIndicators[currentIndexPath] = nil
                }
            }
        }
        
        if ((indexPath.row + 1) == viewModel?.pokemons.count) {
            viewModel?.fetchPokemons()
        }
    }
    
}
