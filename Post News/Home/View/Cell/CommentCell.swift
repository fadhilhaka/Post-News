//
//  CommentCell.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

final class CommentCell: UICollectionViewCell {

    static let identifier = "CommentCell"
    static let cellSize = CGSize(width: UIScreen.main.bounds.width, height: 72.0)
    static func getCellSize(content: String) -> CGSize {
        let cellWidth: CGFloat = UIScreen.main.bounds.width
        let baseHeight: CGFloat = 56.0
        let contentArr = content.split(separator: "\n")
        var contentHeight: CGFloat = 0.0
        
        for str in contentArr {
            let strHeight: CGFloat = String(str).calculateHeight(with: cellWidth-32.0, font: .systemFont(ofSize: 16.0))
            contentHeight += strHeight
        }
        
        let calculatedContentHeight: CGFloat = contentHeight > 20.0 ? contentHeight : 20.0
        let cellHeight: CGFloat = baseHeight + calculatedContentHeight
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(name: String, content: String) {
        nameLabel.text = name
        bodyLabel.text = content
    }
    
}
