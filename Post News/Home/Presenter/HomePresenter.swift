//
//  HomePresenter.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import Foundation

protocol HomePresenterOutput: AnyObject {
    func presentPostList(with data: PostList)
    func presentUserList(with data: UserList)
    func presentError(with errorMessage: String)
}

final class HomePresenter: HomeInteractorOutput {
    let decoder = JSONDecoder()
    var output: HomePresenterOutput!

    func parsingAlbumListData(with data: Data) -> AlbumList {
        var list: AlbumList = []
        
        do {
            let albumList = try decoder.decode(AlbumList.self, from: data)
            if !albumList.isEmpty {
                list = albumList
            }
            
        } catch {
            output.presentError(with: error.localizedDescription)
        }
        
        return list
    }
    
    func parsingCommentListData(with data: Data) -> CommentList {
        var list: CommentList = []
        
        do {
            let commentList = try decoder.decode(CommentList.self, from: data)
            if !commentList.isEmpty {
                list = commentList
            }
            
        } catch {
            output.presentError(with: error.localizedDescription)
        }
        
        return list
    }
    
    func parsingPhotoListData(with data: Data) -> PhotoList {
        var list: PhotoList = []
        
        do {
            let photoList = try decoder.decode(PhotoList.self, from: data)
            if !photoList.isEmpty {
                list = photoList
            }
            
        } catch {
            output.presentError(with: error.localizedDescription)
        }
        
        return list
    }
    
    func parsingPostListData(with data: Data) {
        do {
            let postList = try decoder.decode(PostList.self, from: data)
            if !postList.isEmpty {
                output.presentPostList(with: postList)
            } else {
                output.presentError(with: "Error: List returned empty")
            }
            
        } catch {
            output.presentError(with: error.localizedDescription)
        }
    }
    
    func parsingUserListData(with data: Data) {
        do {
            let userList = try decoder.decode(UserList.self, from: data)
            if !userList.isEmpty {
                output.presentUserList(with: userList)
            } else {
                output.presentError(with: "Error: List returned empty")
            }
            
        } catch {
            output.presentError(with: error.localizedDescription)
        }
    }
    
    func presentError(with error: Error) {
        output.presentError(with: error.localizedDescription)
    }
}
