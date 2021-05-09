//
//  PhotoViewController.swift
//  Post News
//
//  Created by Fadhil Hanri on 10/05/21.
//

import UIKit

final class PhotoViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topSafeAreaConstraint: NSLayoutConstraint!
    @IBOutlet weak var dragIndicatorView: UIView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let imageTitle: String
    let imageStrURL: String
    
    var currentTopConstraint: CGFloat = 0.0
    var previousPosition: CGFloat = 0.0
    var directionIsChanged = false
    
    init(imageTitle: String, imageStrURL: String) {
        self.imageTitle = imageTitle
        self.imageStrURL = imageStrURL
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
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        containerView.layer.cornerRadius = 8.0
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dragIndicatorView.layer.cornerRadius = 2.0
        
        imageTitleLabel.text = imageTitle
        
        guard let imageURL = URL(string: imageStrURL) else { return }
        
        downloadImage(from: imageURL) { (image, error) in
            guard let image = image, error == nil else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = image
            }
        }
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
}
