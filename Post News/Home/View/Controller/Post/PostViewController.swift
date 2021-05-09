//
//  PostViewController.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func getCommentList(completion: @escaping (CommentList?, String?) -> Void)
}

final class PostViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var dragIndicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var bodyLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentCollectionView: UICollectionView!
    @IBOutlet weak var reloadButton: UIButton!
    
    let postViewModel: PostViewModel
    
    var currentTopConstraint: CGFloat = 0.0
    var previousPosition: CGFloat = 0.0
    var directionIsChanged = false
    var commentList: CommentList
    
    weak var parentController: HomeViewController?
    weak var delegate: PostViewControllerDelegate?
    
    init(postViewModel: PostViewModel, commentList: CommentList, delegate: PostViewControllerDelegate?) {
        self.delegate = delegate
        self.postViewModel = postViewModel
        self.commentList = commentList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGesture()
    }
    
    private func setupCollectionView() {
        let layout = commentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.scrollDirection = .vertical
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        commentCollectionView.register(UINib(nibName: CommentCell.identifier, bundle: nil), forCellWithReuseIdentifier: CommentCell.identifier)
    }
    
    private func setupView() {
        let width: CGFloat = UIScreen.main.bounds.width
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupCollectionView()
        
        containerView.layer.cornerRadius = 8.0
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dragIndicatorView.layer.cornerRadius = 2.0
                
        titleLabel.text = postViewModel.title
        usernameLabel.text = "\(postViewModel.username) from \(postViewModel.companyName)"
        bodyLabel.text = postViewModel.content
        
        titleLabelHeightConstraint.constant = postViewModel.title.calculateHeight(with: width-32.0, font: .boldSystemFont(ofSize: 18.0))
        bodyLabelHeightConstraint.constant = postViewModel.content.calculateHeight(with: width-32.0, font: .systemFont(ofSize: 16.0))
        
        commentCollectionView.isHidden = commentList.isEmpty
        reloadButton.isHidden = !commentList.isEmpty
    }
    
    private func setupGesture() {
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(isDragged(_ :)))
            dragGesture.delegate = self
        containerView.addGestureRecognizer(dragGesture)
    }
    
    private func animateView(to position: CGFloat, completion: ((Bool) -> Void)? = nil) {
        topSafeAreaConstraint.constant = position
        UIView.animate(withDuration: 0.5, animations: { self.view.layoutIfNeeded() }, completion: completion)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showUserDetail() {
        let userVC = UserViewController(user: postViewModel.user, delegate: parentController)
            userVC.modalTransitionStyle = .crossDissolve
            userVC.modalPresentationStyle = .overFullScreen
        self.present(userVC, animated: true, completion: nil)
    }
    
    @objc
    func isDragged(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: view)
        let distance = CGFloat(velocity.y/60)
        let movedTopConstraint = topSafeAreaConstraint.constant + distance
        let moveDown = movedTopConstraint > currentTopConstraint

        topSafeAreaConstraint.constant = movedTopConstraint

        switch gesture.state {
        case .changed:
            directionIsChanged = previousPosition > movedTopConstraint
            previousPosition = movedTopConstraint

        case .ended:
            if moveDown && !directionIsChanged {
                animateView(to: UIScreen.main.bounds.height) { success in
                    if success { self.dismiss(animated: false, completion: nil) }
                }

            } else {
                animateView(to: currentTopConstraint)
            }

            directionIsChanged = false

        default: break
        }
    }
    
    @IBAction func reloadCommentList(_ sender: UIButton) {
        delegate?.getCommentList(completion: { data, errorMessage in
            if let errorMessage = errorMessage {
                DispatchQueue.main.async {
                    self.showAlert(errorMessage)
                    self.reloadButton.isHidden = false
                    self.commentCollectionView.isHidden = true
                }
            }
            
            if let data = data, !data.isEmpty {
                DispatchQueue.main.async {
                    self.reloadButton.isHidden = true
                    self.commentCollectionView.isHidden = false
                    self.commentList = data.filter({ $0.postID == self.postViewModel.postID })
                    self.commentCollectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.reloadButton.isHidden = false
                    self.commentCollectionView.isHidden = true
                }
            }
        })
    }
    
    
    @IBAction func usernameIsClicked(_ sender: UIButton) {
        self.showUserDetail()
    }
}

extension PostViewController: UICollectionViewDelegate { }

extension PostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        commentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            cell.setupCell(name: commentList[indexPath.item].name, content: commentList[indexPath.item].body)
        return cell
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let content = commentList[indexPath.item].body
        return CommentCell.getCellSize(content: content)
    }
}
