import UIKit

class PokemonViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()

        icon.isHidden = true
        icon.image = nil
        spinner.isHidden = false
        spinner.startAnimating()
        label.text = nil
    }

    func configure(title: String? = nil, image: UIImage? = nil) {
        label.text = title ?? label.text
        if let image = image {
            icon.isHidden = false
            icon.image = image
            spinner.isHidden = true
            spinner.stopAnimating()
        } else {
            icon.image = nil
            icon.isHidden = true
            spinner.isHidden = false
            spinner.startAnimating()
        }
    }

}
