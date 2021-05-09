//
//  Post_NewsTests.swift
//  Post NewsTests
//
//  Created by Fadhil Hanri on 08/05/21.
//

import XCTest
@testable import Post_News

class Post_NewsTests: XCTestCase {
    
    fileprivate var sut: HomeViewController!
    fileprivate var interactorSpy = HomeInteractorSpy()
    fileprivate var presenterSpy = HomePresenterSpy()
    fileprivate var routerSpy = HomeRouterSpy()
    fileprivate var workerSpy = HomeWorkerSpy()

    override func setUpWithError() throws {
        sut = HomeViewController()
        interactorSpy.worker = workerSpy
        interactorSpy.output = presenterSpy
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_should_be_able_to_request_post_list() {
        sut.interactor = interactorSpy
        sut.interactor.getPostList(HomeNews.Request())
        XCTAssertTrue(interactorSpy.getPostListIsCalled)
    }

    func test_should_be_able_to_request_user_list() {
        sut.interactor = interactorSpy
        sut.interactor.getUserList(HomeNews.Request(selectedPath: .user))
        XCTAssertTrue(interactorSpy.getUserListIsCalled)
    }
    
    func test_should_be_able_to_request_album_list() {
        let expectation = XCTestExpectation(description: "Mock request")
        sut.interactor = interactorSpy
        sut.interactor.getAlbumList(HomeNews.Request(selectedPath: .album)) { _, _ in
            expectation.fulfill()
        }
        XCTAssertTrue(interactorSpy.getAlbumListIsCalled)
    }
    
    func test_should_be_able_to_request_comment_list() {
        let expectation = XCTestExpectation(description: "Mock request")
        sut.interactor = interactorSpy
        sut.interactor.getCommentList(HomeNews.Request(selectedPath: .comment)) { _, _ in
            expectation.fulfill()
        }
        XCTAssertTrue(interactorSpy.getCommentListIsCalled)
    }
    
    func test_should_be_able_to_request_photo_list() {
        let expectation = XCTestExpectation(description: "Mock request")
        sut.interactor = interactorSpy
        sut.interactor.getPhotoList(HomeNews.Request(selectedPath: .photo)) { _, _ in
            expectation.fulfill()
        }
        XCTAssertTrue(interactorSpy.getPhotoListIsCalled)
    }
}

fileprivate enum TestError: Error {
    case expectedError
}

fileprivate func throwError() -> TestError {
    return .expectedError
}

fileprivate class HomeInteractorSpy: HomeInteractorInput {
    var output: HomeInteractorOutput!
    
    var worker: HomeWorkerDelegate!
    
    var getAlbumListIsCalled = false
    func getAlbumList(_ request: HomeNews.Request, completion: @escaping (AlbumList?, String?) -> Void) {
        getAlbumListIsCalled = true
    }
    
    var getCommentListIsCalled = false
    func getCommentList(_ request: HomeNews.Request, completion: @escaping (CommentList?, String?) -> Void) {
        getCommentListIsCalled = true
    }
    
    var getPhotoListIsCalled = false
    func getPhotoList(_ request: HomeNews.Request, completion: @escaping (PhotoList?, String?) -> Void) {
        getPhotoListIsCalled = true
    }
    
    var getPostListIsCalled = false
    func getPostList(_ request: HomeNews.Request) {
        getPostListIsCalled = true
    }
    
    var getUserListIsCalled = false
    func getUserList(_ request: HomeNews.Request) {
        getUserListIsCalled = true
    }
}

fileprivate class HomePresenterSpy: HomeInteractorOutput {
    func parsingAlbumListData(with data: Data) -> AlbumList {
        []
    }
    
    func parsingCommentListData(with data: Data) -> CommentList {
        []
    }
    
    func parsingPhotoListData(with data: Data) -> PhotoList {
        []
    }
    
    func parsingPostListData(with data: Data) {
        
    }
    
    func parsingUserListData(with data: Data) {
        
    }
    
    func presentError(with error: Error) {
        
    }
}

fileprivate class HomeRouterSpy: HomeRouterDelegate {
    func showAlert(_ message: String) {
        
    }
    
    func showPostDetail(_ viewModel: PostViewModel, commentList: CommentList) {
        
    }
    
    func showUserDetail(_ user: UserResponse) {
        
    }
}

fileprivate class HomeWorkerSpy: HomeWorkerDelegate {
    func getAlbumList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
    }
    
    func getCommentList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
    }
    
    func getPhotoList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
    }
    
    func getPostList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
    }
    
    func getUserList(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
    }
}
