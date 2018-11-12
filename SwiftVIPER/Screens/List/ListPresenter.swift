//
//  ListPresenter.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
/// Must not import UIKit

typealias ListPresenterDependencies = (
    interactor: ListInteractor,
    router: ListRouterOutput
)

final class ListPresenter: Presenterable {

    internal var entities: ListEntities
    private weak var view: ListViewInputs!
    let dependencies: ListPresenterDependencies

    init(entities: ListEntities,
         view: ListViewInputs,
         dependencies: ListPresenterDependencies)
    {
        self.view = view
        self.entities = entities
        self.dependencies = dependencies
    }

}

extension ListPresenter: ListViewOutputs {
    func viewDidLoad() {
        entities.searchApiState.isFetching = true
        dependencies.interactor.fetchSearch(page: entities.searchApiState.pageCount)
    }

    func onCloseButtonTapped() {
        dependencies.router.dismiss(animated: true)
    }

    func onReachBottom() {
        guard !entities.searchApiState.isFetching else { return }
        entities.searchApiState.isFetching = true
        dependencies.interactor.fetchSearch(page: entities.searchApiState.pageCount)
    }
}

extension ListPresenter: ListInteractorOutputs {
    func onSuccessSearch(res: SearchRepositoriesResponse) {
        entities.searchApiState.isFetching = false
        entities.searchApiState.pageCount += 1
        entities.searchApiState.gitHubRepositories += res.items
        view.reloadTableView(tableViewDataSource: ListTableViewDataSource(entities: entities, delegate: self))
    }

    func onErrorSearch(error: Error) {

    }
}

extension ListPresenter: ListTableViewDataSourceDelegate {
    func didSelect(_ gitHubRepository: GitHubRepository) {
        dependencies.router.transitionDetail(gitHubRepository: gitHubRepository)
    }
}
