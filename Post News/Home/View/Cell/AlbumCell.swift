//
//  AlbumCell.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

final class AlbumCell: UICollectionViewCell {

    static let identifier = "AlbumCell"
    static let cellSize = CGSize(width: 60.0, height: 60.0)
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4.0
        contentView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 4.0
    }

    func setupCell(_ thumbnailStrURL: String, imageStrURL: String) {
        guard let imageURL = URL(string: thumbnailStrURL) else { return }
        
        downloadImage(from: imageURL) { (image, error) in
            guard let image = image, error == nil else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = image
            }
        }
    }

    func downloadImage(from imageURL: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        getImage(from: imageURL) { (data, _, error) in
            if let error = error {
                print("Error received requesting plant image: \(error.localizedDescription)")
                completion(nil, error)
            }
            
            if let imageData = data {
                print("Image is downloaded")
                completion(UIImage(data: imageData), nil)
            }
        }
        print("Image is downloading")
    }
    
    func getImage(from imageURL: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: imageURL, completionHandler: completion).resume()
    }
}
