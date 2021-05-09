//
//  AlbumHeaderView.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

final class AlbumHeaderView: UICollectionReusableView {

    static let identifier = "AlbumHeaderView"
    static func getHeaderSize(title: String) -> CGSize {
        let headerWidth: CGFloat = UIScreen.main.bounds.width
        let baseHeight: CGFloat = 24.0
        let titleHeight: CGFloat = title.calculateHeight(with: headerWidth-32.0, font: .systemFont(ofSize: 16.0, weight: .semibold))
        let calculatedTitleHeight: CGFloat = titleHeight > 20.0 ? titleHeight : 20.0
        let headerHeight: CGFloat = baseHeight + calculatedTitleHeight
        return CGSize(width: headerWidth, height: headerHeight)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupHeader(_ title: String, isFirst: Bool) {
        titleLabel.text = title
        separatorView.isHidden = isFirst
    }
}
