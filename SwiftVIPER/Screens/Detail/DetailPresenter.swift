//
//  DetailPresenter.swift
//  SwiftVIPER
//
//  Created by 林　翼 on 2018/11/12.
//  Copyright © 2018年 Tsubasa Hayashi. All rights reserved.
//

import Foundation
import WebKit

typealias DetailPresenterDependencies = (
    interactor: DetailInteractor,
    router: DetailRouterOutput
)

final class DetailPresenter: Presenterable {

    internal var entities: DetailEntities
    private weak var view: DetailViewInputs!
    let dependencies: DetailPresenterDependencies

    init(entities: DetailEntities,
         view: DetailViewInputs,
         dependencies: DetailPresenterDependencies)
    {
        self.view = view
        self.entities = entities
        self.dependencies = dependencies
    }

}

extension DetailPresenter: DetailViewOutputs {

    func viewDidLoad() {
        view.requestWebView(with: URLRequest(url: URL(string: entities.entryEntity.gitHubRepository.url)!))
        view.indicatorView(animate: true)
        view.configure(entities: entities)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.indicatorView(animate: false)
    }
}

extension DetailPresenter: DetailInteractorOutputs {}
