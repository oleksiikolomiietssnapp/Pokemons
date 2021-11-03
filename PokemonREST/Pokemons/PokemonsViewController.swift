import UIKit

class PokemonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: PokemonsViewModel!
    
    private var activityIndicators = [IndexPath: UIActivityIndicatorView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PokemonViewCell", bundle: nil),
                           forCellReuseIdentifier: "PokemonViewCell")
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
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonViewCell", for: indexPath) as? PokemonViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PokemonViewCell else {
            return
        }

        let pokemon = viewModel.items[indexPath.row]
        cell.configure(title: pokemon.name)

        viewModel?.fetchPokemonImage(at: indexPath) { data in
            DispatchQueue.main.async {
                cell.configure(image: UIImage(data: data))
            }
        }
    }
    
}
