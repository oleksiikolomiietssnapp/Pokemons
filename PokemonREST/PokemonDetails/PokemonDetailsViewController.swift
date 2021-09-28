//
//  PokemonDetails.swift
//  PokemonREST
//
//  Created by Oleksii Kolomiiets on 28.09.2021.
//

import WebKit
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
        return viewModel?.cache.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let image = UIImage(data: viewModel!.cache[indexPath.row]) {
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(imageView)
            cell.contentView.addConstraints([
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 56),
                imageView.widthAnchor.constraint(equalToConstant: 56)
            ])
        } else {
            // TODO: SVG image could be shown in the web view =(. Look for other approaches.
            let webView = WKWebView(frame: cell.contentView.bounds)
            let request = URLRequest(url: viewModel!.urls[indexPath.row])
            webView.load(request)
            webView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(webView)
            cell.contentView.addConstraints([
                webView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                webView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                webView.heightAnchor.constraint(equalToConstant: 56),
                webView.widthAnchor.constraint(equalToConstant: 56)
            ])
        }
    }
}
