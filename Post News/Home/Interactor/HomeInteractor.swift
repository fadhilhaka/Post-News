//
//  HomeInteractor.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import Foundation

protocol HomeInteractorInput: AnyObject {
    var output: HomeInteractorOutput! { get set }
    var worker: HomeWorkerDelegate! { get set }
    
    func getAlbumList(_ request: HomeNews.Request, completion: @escaping (AlbumList?, String?) -> Void)
    func getCommentList(_ request: HomeNews.Request, completion: @escaping (CommentList?, String?) -> Void)
    func getPhotoList(_ request: HomeNews.Request, completion: @escaping (PhotoList?, String?) -> Void)
    func getPostList(_ request: HomeNews.Request)
    func getUserList(_ request: HomeNews.Request)
}

protocol HomeInteractorOutput: AnyObject {
    func parsingAlbumListData(with data: Data) -> AlbumList
    func parsingCommentListData(with data: Data) -> CommentList
    func parsingPhotoListData(with data: Data) -> PhotoList
    func parsingPostListData(with data: Data)
    func parsingUserListData(with data: Data)
    func presentError(with error: Error)
}

final class HomeInteractor: HomeInteractorInput {
    var output: HomeInteractorOutput!
    var worker: HomeWorkerDelegate!
    
    func getAlbumList(_ request: HomeNews.Request, completion: @escaping (AlbumList?, String?) -> Void) {
        guard let url = URL(string: request.stringURL) else { return }
        var urlRequest = URLRequest(url: url)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        worker.getAlbumList(request: urlRequest) { data, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let data = data {
                let albumList = self.output.parsingAlbumListData(with: data)
                completion(albumList, nil)
            }
        }
    }
    
    func getCommentList(_ request: HomeNews.Request, completion: @escaping (CommentList?, String?) -> Void) {
        guard let url = URL(string: request.stringURL) else { return }
        var urlRequest = URLRequest(url: url)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        worker.getCommentList(request: urlRequest) { data, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let data = data {
                let commentList = self.output.parsingCommentListData(with: data)
                completion(commentList, nil)
            }
        }
    }
    
    func getPhotoList(_ request: HomeNews.Request, completion: @escaping (PhotoList?, String?) -> Void) {
        guard let url = URL(string: request.stringURL) else { return }
        var urlRequest = URLRequest(url: url)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        worker.getPhotoList(request: urlRequest) { data, error in
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            if let data = data {
                let photoList = self.output.parsingPhotoListData(with: data)
                completion(photoList, nil)
            }
        }
    }
    
    func getPostList(_ request: HomeNews.Request) {
        guard let url = URL(string: request.stringURL) else { return }
        var urlRequest = URLRequest(url: url)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        worker.getPostList(request: urlRequest) { data, error in
            if let error = error {
                self.output.presentError(with: error)
            }
            
            if let data = data {
                self.output.parsingPostListData(with: data)
            }
        }
    }
    
    func getUserList(_ request: HomeNews.Request) {
        guard let url = URL(string: request.stringURL) else { return }
        var urlRequest = URLRequest(url: url)
            urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        worker.getPostList(request: urlRequest) { data, error in
            if let error = error {
                self.output.presentError(with: error)
            }
            
            if let data = data {
                self.output.parsingUserListData(with: data)
            }
        }
    }
}
