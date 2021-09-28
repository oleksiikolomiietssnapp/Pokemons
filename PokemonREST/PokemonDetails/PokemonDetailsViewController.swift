//
//  PokemonDetails.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 28.09.2021.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: PokemonDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = (viewModel?.details.name ?? "unknown name").capitalized
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension PokemonDetailsViewController: UICollectionViewDelegate {
    
}

extension PokemonDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.details.spritesCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let image = UIImage(data: viewModel!.cache[indexPath.row])
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)
        cell.contentView.addConstraints([
            imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 56),
            imageView.widthAnchor.constraint(equalToConstant: 56)
        ])
    }
}

class PokemonDetailsViewModel {
    
    let details: PokemonDetailsResponse
    private(set) var cache: [Data] = []
    
    init(details: PokemonDetailsResponse) {
        self.details = details
        
        let sprites = details.sprites.front.sprites + details.sprites.back.sprites
        cache = try! sprites
            .map { sprite in 
                guard let url = URL(string: sprite)
                else { throw APIError.brokenURL }
                
                return try Data(contentsOf: url)
            }
    }
}
