//
//  HomeConfigurator.swift
//  Post News
//
//  Created by Fadhil Hanri on 09/05/21.
//

import Foundation

import UIKit

final class HomeConfigurator {
    
    static func configure(_ viewController: HomeViewController) {
        let router = HomeRouter()
            router.parentController = viewController

        let presenter = HomePresenter()
            presenter.output = viewController

        let interactor = HomeInteractor()
            interactor.output = presenter
            interactor.worker = HomeWorker()

        viewController.interactor = interactor
        viewController.router = router
    }
}
