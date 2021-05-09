//
//  HomeWorker.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import Foundation

protocol HomeWorkerDelegate: AnyObject {
    func getAlbumList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
    func getCommentList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
    func getPhotoList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
    func getPostList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
    func getUserList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
}

final class HomeWorker: HomeWorkerDelegate {
    var getAlbumListTask: URLSessionDataTask?
    var getCommentListTask: URLSessionDataTask?
    var getPhotoListTask: URLSessionDataTask?
    var getPostListTask: URLSessionDataTask?
    var getUserListTask: URLSessionDataTask?
    
    func getAlbumList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        getAlbumListTask?.cancel()
        getAlbumListTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error received requesting AlbumList: \(error.localizedDescription)")
                completion(nil, error)
            }

            if let data = data, !data.isEmpty {
                completion(data, nil)
            }
        }
        getAlbumListTask?.resume()
    }
    
    func getCommentList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        getCommentListTask?.cancel()
        getCommentListTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error received requesting CommentList: \(error.localizedDescription)")
                completion(nil, error)
            }

            if let data = data, !data.isEmpty {
                completion(data, nil)
            }
        }
        getCommentListTask?.resume()
    }
    
    func getPhotoList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        getPhotoListTask?.cancel()
        getPhotoListTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error received requesting PhotoList: \(error.localizedDescription)")
                completion(nil, error)
            }

            if let data = data, !data.isEmpty {
                completion(data, nil)
            }
        }
        getPhotoListTask?.resume()
    }
    
    func getPostList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        getPostListTask?.cancel()
        getPostListTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error received requesting PostList: \(error.localizedDescription)")
                completion(nil, error)
            }

            if let data = data, !data.isEmpty {
                completion(data, nil)
            }
        }
        getPostListTask?.resume()
    }
    
    func getUserList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        getUserListTask?.cancel()
        getUserListTask = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error received requesting UserList: \(error.localizedDescription)")
                completion(nil, error)
            }

            if let data = data, !data.isEmpty {
                completion(data, nil)
            }
        }
        getUserListTask?.resume()
    }
}
