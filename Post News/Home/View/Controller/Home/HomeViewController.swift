//
//  HomeViewController.swift
//  Post News
//
//  Created by Fadhil Hanri on 08/05/21.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var interactor: HomeInteractorInput!
    var router: HomeRouterDelegate!
    var postList: PostList = []
    var userList: UserList = []
    var commentList: CommentList = []
    var albumList: AlbumList = []
    var photoList: PhotoList = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        HomeConfigurator.configure(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        HomeConfigurator.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupCollectionView()
        refreshData(refreshControl)
    }

    private func setupCollectionView() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.scrollDirection = .vertical
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PostCell.identifier, bundle: nil), forCellWithReuseIdentifier: PostCell.identifier)
        collectionView.refreshControl = refreshControl
    }
    
    @objc
    func refreshData(_ sender: UIRefreshControl) {
        refreshControl.beginRefreshing()
        interactor.getUserList(HomeNews.Request(selectedPath: .user))
    }
}

extension HomeViewController: UICollectionViewDelegate { }

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let user = userList[postList[indexPath.item].userID-1]
        let viewModel = PostViewModel.create(from: postList[indexPath.item], by: user)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.identifier, for: indexPath) as! PostCell
            cell.setupCell(with: viewModel, delegate: self)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        PostCell.cellSize
    }
}

extension HomeViewController: PostCellDelegate {
    func showPostDetail(at postID: Int, by user: UserResponse) {
        let postViewModel = PostViewModel.create(from: postList[postID-1], by: user)
        router.showPostDetail(postViewModel, commentList: commentList)
    }
    
    func showUserDetail(_ user: UserResponse) {
        router.showUserDetail(user)
    }
}

extension HomeViewController: HomePresenterOutput {
    func presentPostList(with data: PostList) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.postList = data
            self.collectionView.reloadData()
        }
    }
    
    func presentUserList(with data: UserList) {
        DispatchQueue.main.async {
            self.userList = data
            self.interactor.getPostList(HomeNews.Request())
        }
    }
    
    func presentError(with errorMessage: String) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.router.showAlert(errorMessage)
        }
    }
}

extension HomeViewController: PostViewControllerDelegate {
    func getCommentList(completion: @escaping (CommentList?, String?) -> Void) {
        if commentList.isEmpty {
            interactor.getCommentList(HomeNews.Request(selectedPath: .comment)) { list, errorMessage in
                if let errorMessage = errorMessage {
                    completion(nil, errorMessage)
                }
                
                if let commentList = list {
                    self.commentList = commentList
                    completion(commentList, nil)
                }
            }
        } else {
            completion(nil, "Comment is empty")
        }
    }
}

extension HomeViewController: UserViewControllerDelegate {
    func getAlbumList(completion: @escaping (AlbumList?, String?) -> Void) {
        if albumList.isEmpty {
            interactor.getAlbumList(HomeNews.Request(selectedPath: .album)) { list, errorMessage in
                if let errorMessage = errorMessage {
                    completion(nil, errorMessage)
                }
                
                if let albumList = list {
                    self.albumList = albumList
                    completion(albumList, nil)
                }
            }
        } else {
            completion(self.albumList, nil)
        }
    }
    
    func getPhotoList(completion: @escaping (PhotoList?, String?) -> Void) {
        if photoList.isEmpty {
            interactor.getPhotoList(HomeNews.Request(selectedPath: .photo)) { list, errorMessage in
                if let errorMessage = errorMessage {
                    completion(nil, errorMessage)
                }
                
                if let photoList = list {
                    self.photoList = photoList
                    completion(photoList, nil)
                }
            }
        } else {
            completion(self.photoList, nil)
        }
    }
}
