//
//  PostCell.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func showPostDetail(at postID: Int, by user: UserResponse)
    func showUserDetail(_ user: UserResponse)
}

final class PostCell: UICollectionViewCell {
    
    static let identifier = "PostCell"
    static let cellSize = CGSize(width: UIScreen.main.bounds.width, height: 86.0)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: PostCellDelegate?
    
    private var postID: Int?
    private var user: UserResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(with viewModel: PostViewModel, delegate: PostCellDelegate) {
        self.delegate = delegate
        cellWidthConstraint.constant = UIScreen.main.bounds.width
        titleLabel.text = viewModel.title
        usernameLabel.text = "\(viewModel.username) from \(viewModel.companyName)"
        bodyLabel.text = viewModel.content
        postID = viewModel.postID
        user = viewModel.user
    }
    
    @IBAction func postIsClicked(_ sender: UIButton) {
        guard let postID = self.postID,
              let user = self.user
        else { return }
        delegate?.showPostDetail(at: postID, by: user)
    }
    
    @IBAction func usernameIsClicked(_ sender: UIButton) {
        guard let user = self.user else { return }
        delegate?.showUserDetail(user)
    }
}
