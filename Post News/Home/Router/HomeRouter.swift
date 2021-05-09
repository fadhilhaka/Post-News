//
//  HomeRouter.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

protocol HomeRouterDelegate {
    func showAlert(_ message: String)
    func showPostDetail(_ viewModel: PostViewModel, commentList: CommentList)
    func showUserDetail(_ user: UserResponse)
}

final class HomeRouter: HomeRouterDelegate {
    weak var parentController: HomeViewController?
    private var navController: UINavigationController? { parentController?.navigationController }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        parentController?.present(alert, animated: true, completion: nil)
    }
    
    func showPostDetail(_ viewModel: PostViewModel, commentList: CommentList) {
        let postVC = PostViewController(postViewModel: viewModel, commentList: commentList, delegate: parentController)
            postVC.parentController = parentController
            postVC.modalTransitionStyle = .crossDissolve
            postVC.modalPresentationStyle = .overFullScreen
        parentController?.present(postVC, animated: true, completion: nil)
    }
    
    func showUserDetail(_ user: UserResponse) {
        let userVC = UserViewController(user: user, delegate: parentController)
            userVC.modalTransitionStyle = .crossDissolve
            userVC.modalPresentationStyle = .overFullScreen
        parentController?.present(userVC, animated: true, completion: nil)
    }
}
