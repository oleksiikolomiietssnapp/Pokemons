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
    let pokemonCell = "PokemonCell"
    
    private var activityIndicators = [IndexPath: UIActivityIndicatorView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareTableView()
        prepareViewModel()
    }
    func setupCell(){
        tableView.register(UINib(nibName: pokemonCell, bundle: nil), forCellReuseIdentifier: pokemonCell)
    }
    func prepareViewModel(){
        viewModel = PokemonsViewModel()
        
        viewModel?.subscribe { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.tableView.reloadData()
        }
        viewModel?.fetchPokemons()
    }
    
    func prepareTableView(){
        tableView.register(UINib(nibName: pokemonCell, bundle: nil), forCellReuseIdentifier: pokemonCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func prepareNavigationBar(){
        title = "Pokemon"
        
        let reverseButton = UIBarButtonItem(image: UIImage(systemName: "tray.and.arrow.down"), style: .plain, target: self, action: #selector(reverse))
        reverseButton.tintColor = .systemOrange
       
        let menuItems: [UIAction] = [
                UIAction(title: "Weight", image: UIImage(named: "weight-scale"), handler: { (_) in
                         }),
                UIAction(title: "Height", image: UIImage(named: "height"), handler: { (_) in
                }),
                UIAction(title: "Base experience", image: UIImage(named: "certificate"), handler: { (_) in
                })
            ]

        let demoMenu: UIMenu = UIMenu(title: "Filter for...",
                          image: nil,
                          identifier: nil,
                          options: [],
                          children: menuItems)
        

        let filterButton = UIBarButtonItem(image: UIImage(named: "filter"), primaryAction: nil, menu: demoMenu)
        filterButton.tintColor = .systemOrange
        
        navigationItem.rightBarButtonItems = [reverseButton, filterButton]
        
    }
    
    @objc func reverse() {
        guard let viewModel = viewModel else { return }
        viewModel.toggleReverse()
        
        let imageName = viewModel.isReversed ? "tray.and.arrow.up" : "tray.and.arrow.down"
        navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: imageName)
    }
    
    @objc func filter() {
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.pokemons.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: pokemonCell, for: indexPath) as! PokemonCell
        cell.set(pokemon: viewModel!.pokemons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: Look why spinner iis there for 'kommo-0-totem'
        
        // MARK: Fetching next page with pokemons
        //        if ((indexPath.row + 1) == viewModel?.pokemons.count) {
        //            viewModel?.fetchPokemons()
        //        }
    }
    
}
