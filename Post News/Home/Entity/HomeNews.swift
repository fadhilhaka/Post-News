//
//  HomeNews.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import Foundation

typealias AlbumList = [HomeNews.Response.Album]
typealias CommentList = [HomeNews.Response.Comment]
typealias PhotoList = [HomeNews.Response.Photo]
typealias PostList = [HomeNews.Response.UserPost]
typealias PostResponse = HomeNews.Response.UserPost
typealias PostViewModel = HomeNews.ViewModel.UserPost
typealias UserList = [HomeNews.Response.User]
typealias UserResponse = HomeNews.Response.User

struct HomeNews {
    // MARK: - Request
    struct Request {
        static let baseURL = PlistHandler.configuration(.WebURL)

        enum Path: String {
            case post = "posts"
            case user = "users"
            case comment = "comments"
            case album = "albums"
            case photo = "photos"
            
            var query: String {
                baseURL + self.rawValue
            }
        }
        
        var selectedPath: Path = .post
        var stringURL: String {
            get { selectedPath.query }
        }
    }
    
    // MARK: - Response
    struct Response {
        // MARK: - UserPost
        struct UserPost: Codable {
            let userID, postID: Int
            let title, body: String

            enum CodingKeys: String, CodingKey {
                case userID = "userId"
                case postID = "id"
                case title, body
            }
        }
        
        // MARK: - User
        struct User: Codable {
            let userID: Int
            let name, username, email: String
            let address: Address
            let company: Company
            
            enum CodingKeys: String, CodingKey {
                case userID = "id"
                case name, username, email, address, company
            }
            
            // MARK: - Address
            struct Address: Codable {
                let street, suite, city, zipcode: String
            }

            // MARK: - Company
            struct Company: Codable {
                let name: String
            }
        }
        
        // MARK: - Comment
        struct Comment: Codable {
            let postID, commentID: Int
            let name, body: String

            enum CodingKeys: String, CodingKey {
                case postID = "postId"
                case commentID = "id"
                case name, body
            }
        }
        
        // MARK: - Album
        struct Album: Codable {
            let userID, albumID: Int
            let title: String

            enum CodingKeys: String, CodingKey {
                case userID = "userId"
                case albumID = "id"
                case title
            }
        }

        // MARK: - Photo
        struct Photo: Codable {
            let albumID, photoID: Int
            let title: String
            let url, thumbnailURL: String

            enum CodingKeys: String, CodingKey {
                case albumID = "albumId"
                case photoID = "id"
                case title, url
                case thumbnailURL = "thumbnailUrl"
            }
        }
    }
    
    // MARK: - ViewModel
    struct ViewModel {
        struct UserPost {
            let title: String
            let username: String
            let companyName: String
            let content: String
            let postID: Int
            let user: UserResponse
            
            static func create(from post: PostResponse, by user: UserResponse) -> PostViewModel {
                PostViewModel(title: post.title, username: user.username, companyName: user.company.name, content: post.body, postID: post.postID, user: user)
            }
        }
    }
}
