//
//  ListRouter.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import UIKit


// MARK: Initialize List Screen
// Can transion List Screen Call by ListRouterInput
struct ListRouterInput {

    private static func view(entryEntity: ListEntryEntity) -> ListViewController {
        let view = ListViewController()
        let interactor = ListInteractor()
        let dependencies = ListPresenterDependencies(interactor: interactor, router: ListRouterOutput(view))
        let presenter = ListPresenter(entities: ListEntities(entryEntity: entryEntity), view: view, dependencies: dependencies)
        view.presenter = presenter
        view.tableViewDataSource = ListTableViewDataSource(entities: presenter.entities, delegate: presenter)
        interactor.presenter = presenter
        return view
    }

    func push(from: Viewable, entryEntity: ListEntryEntity) {
        let view = ListRouterInput.view(entryEntity: entryEntity)
        from.push(view, animated: true)
    }

    func present(from: Viewable, entryEntity: ListEntryEntity) {
        let nav = UINavigationController(rootViewController: ListRouterInput.view(entryEntity: entryEntity))
        from.present(nav, animated: true)
    }
}

final class ListRouterOutput: Routerable {

    private(set) weak var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

    func transitionDetail(gitHubRepository: GitHubRepository) {
        DetailRouterInput().push(from: view, entryEntity: DetailEntryEntity(gitHubRepository: gitHubRepository))
    }
}


