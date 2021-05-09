//
//  AlbumHeaderView.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

final class AlbumHeaderView: UICollectionReusableView {

    static let identifier = "AlbumHeaderView"
    static let headerSize = CGSize(width: UIScreen.main.bounds.width, height: 44.0)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupHeader(_ title: String) {
        titleLabel.text = title
    }
}
