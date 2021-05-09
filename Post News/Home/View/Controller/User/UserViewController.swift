//
//  UserViewController.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import UIKit

protocol UserViewControllerDelegate: AnyObject {
    func getAlbumList(completion: @escaping (AlbumList?, String?) -> Void)
    func getPhotoList(completion: @escaping (PhotoList?, String?) -> Void)
}

final class UserViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var dragIndicatorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    let user: UserResponse
    
    var currentTopConstraint: CGFloat = 0.0
    var previousPosition: CGFloat = 0.0
    var directionIsChanged = false
    var albumList: AlbumList = []
    var photoList: PhotoList = []
    
    weak var delegate: UserViewControllerDelegate?
    
    init(user: UserResponse, delegate: UserViewControllerDelegate?) {
        self.user = user
        self.delegate = delegate
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
        let layout = albumCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.scrollDirection = .vertical
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(UINib(nibName: AlbumCell.identifier, bundle: nil), forCellWithReuseIdentifier: AlbumCell.identifier)
        albumCollectionView.register(UINib(nibName: AlbumHeaderView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AlbumHeaderView.identifier)
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupCollectionView()
        
        containerView.layer.cornerRadius = 8.0
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dragIndicatorView.layer.cornerRadius = 2.0
        
        nameLabel.text = "Name: \(user.name)"
        emailLabel.text = "Email: \(user.email)"
        addressLabel.text = "Address: \(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
        companyLabel.text = "Company: \(user.company.name)"
        
        albumCollectionView.isHidden = albumList.isEmpty
        reloadButton.isHidden = !albumList.isEmpty
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
    
    func getPhotoList() {
        delegate?.getPhotoList(completion: { data, errorMessage in
            if let errorMessage = errorMessage {
                DispatchQueue.main.async {
                    self.showAlert(errorMessage)
                    self.reloadButton.isHidden = false
                    self.albumCollectionView.isHidden = true
                }
            }
            
            if let data = data, !data.isEmpty {
                DispatchQueue.main.async {
                    self.photoList = data
                    
                    if !self.photoList.isEmpty {
                        self.albumCollectionView.reloadData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.reloadButton.isHidden = false
                    self.albumCollectionView.isHidden = true
                }
            }
        })
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
    
    @IBAction func reloadAlbumList(_ sender: UIButton) {
        delegate?.getAlbumList(completion: { data, errorMessage in
            if let errorMessage = errorMessage {
                DispatchQueue.main.async {
                    self.showAlert(errorMessage)
                    self.reloadButton.isHidden = false
                    self.albumCollectionView.isHidden = true
                }
            }
            
            if let data = data, !data.isEmpty {
                DispatchQueue.main.async {
                    self.reloadButton.isHidden = true
                    self.albumCollectionView.isHidden = false
                    self.albumList = data.filter({ $0.userID == self.user.userID })
                    
                    if self.photoList.isEmpty {
                        self.getPhotoList()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.reloadButton.isHidden = false
                    self.albumCollectionView.isHidden = true
                }
            }
        })
    }
}

extension UserViewController: UICollectionViewDelegate { }

extension UserViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoList.filter { $0.albumID-1 == section }.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AlbumHeaderView.identifier, for: indexPath) as! AlbumHeaderView
        header.setupHeader(albumList[indexPath.section].title, isFirst: indexPath.section == 0)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photoList.filter { $0.albumID-1 == indexPath.section }[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
            cell.setupCell(photo.thumbnailURL, title: photo.title, imageStrURL: photo.url, delegate: self)
        return cell
    }
}

extension UserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        AlbumHeaderView.getHeaderSize(title: albumList[section].title)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        AlbumCell.cellSize
    }
}

extension UserViewController: AlbumCellDelegate {
    func showPhotoDetail(_ title: String, _ imageStrURL: String) {
        let photoVC = PhotoViewController(imageTitle: title, imageStrURL: imageStrURL)
            photoVC.modalTransitionStyle = .crossDissolve
            photoVC.modalPresentationStyle = .overFullScreen
        self.present(photoVC, animated: true, completion: nil)
    }
}
